import json
import requests
from supabase import Client, create_client
import firebase_admin
from firebase_admin import credentials, messaging

def lambda_handler(event, context):
    cred = credentials.Certificate("serviceAccountKey.json")
    app = firebase_admin.initialize_app(cred)

    #get list of games from our database
    supabase: Client = create_client(
        "https://omwsjuhjvdtrumtxrbdc.supabase.co",
        "sb_publishable_-iBJqiDtWU5phXmV4ZBJYA_R2cEVn_n"
    )

    supabase_games = json.loads(supabase.table("game").select("*").execute().model_dump_json())["data"]
    supabase_game_map = {game["gid"]: game for game in supabase_games}

    #contact steam api to get current price of each game
    gameidsstr = ",".join(map(str, supabase_game_map.keys()))
    steam_response = requests.get(f"https://store.steampowered.com/api/appdetails?appids={gameidsstr}&filters=price_overview")
    if steam_response.status_code == 200:
        steam_response = steam_response.json()

        for gameid in supabase_game_map.keys():
            steam_game = steam_response[str(gameid)]
            if steam_game["success"]:
                price = steam_game["data"]["price_overview"]["final"]
                percent = steam_game["data"]["price_overview"]["discount_percent"]
                # create a new price history record for each game
                supabase.table("pricehistory").insert({"gid": gameid, "price": price, "percent": percent}).execute()
                #update game with relevant price information
                if supabase_game_map[gameid]["bestrecordedprice"] > price:
                    supabase.table("game").update({
                        "currentprice": price,
                        "currentpercent": percent,
                        "bestrecordedprice": price,
                        "bestrecordedpercent": percent
                    }).eq("gid", gameid).execute()
                else:
                    supabase.table("game").update({
                        "currentprice": price,
                        "currentpercent": percent
                    }).eq("gid", gameid).execute()

    #get subscriptions from our database
    price_history = json.loads(supabase.table("game_recent_prices").select("*").execute().model_dump_json())["data"]
    index = 0
    cont = True
    while cont:
        try:
            today_ph = price_history[index]
            if today_ph["rn"] != 1:
                raise Exception("Malformed price history data")

            try:
                yesterday_ph = price_history[index + 1]
                if yesterday_ph["rn"] != 2:
                    raise Exception("Only one price history record so far")

                #if we got here, we have two price history records
                if yesterday_ph["dollarthreshold"] is not None and yesterday_ph["price"] >= yesterday_ph["dollarthreshold"] or yesterday_ph["percentthreshold"] is not None and yesterday_ph["percent"] <= yesterday_ph["percentthreshold"]:
                    if today_ph["dollarthreshold"] is not None and today_ph["price"] < today_ph["dollarthreshold"] or today_ph["percentthreshold"] is not None and today_ph["percent"] > today_ph["percentthreshold"]:
                        game_name = today_ph["name"]
                        today_price = today_ph["price"]
                        today_percent = today_ph["percent"]
                        response = messaging.send(messaging.Message(
                            notification=messaging.Notification(
                                title=f"{game_name} dropped in price!",
                                body=f"Price dropped to {str(today_price)}, a {str(today_percent)}% discount!"
                            ),
                            token=today_ph["fcmtoken"]
                        ))
                index += 2
            except Exception:
                #if we got here, we only have one price history record
                if today_ph["dollarthreshold"] is not None and today_ph["price"] < today_ph["dollarthreshold"] or today_ph["percentthreshold"] is not None and today_ph["percent"] > today_ph["percentthreshold"]:
                    game_name = today_ph["name"]
                    today_price = today_ph["price"]
                    today_percent = today_ph["percent"]
                    response = messaging.send(messaging.Message(
                        notification=messaging.Notification(
                            title=f"{game_name} dropped in price!",
                            body=f"Price dropped to {str(today_price)}, a {str(today_percent)}% discount!"
                        ),
                        token=today_ph["fcmtoken"]
                    ))

                index += 1

        except Exception:
            cont = False