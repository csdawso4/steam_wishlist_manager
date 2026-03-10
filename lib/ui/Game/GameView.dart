import 'package:flutter/material.dart';
import '../core/Price.dart';
import 'GameViewModel.dart';

class GameView extends StatelessWidget {
  const GameView({super.key, required this.gameVM});

  final GameViewModel gameVM;

  //TODO: add a way to view current notif sub and delete it. stuff to add new sub should not appear until you delete old one.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 64.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      gameVM.goBackToWishlist(context);
                    },
                    child: Icon(Icons.chevron_left),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.network(gameVM.game.game.capsuleimgurl),
                      SizedBox(width: 10),
                      Text(gameVM.game.game.name),
                    ],
                  ),
                  Row(
                    children: [
                      if (gameVM.game.game.currentpercent != 0)
                        Text("-${gameVM.game.game.currentpercent}%"),
                      SizedBox(width: 10),
                      Price(price: gameVM.game.game.currentprice),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Text("Best recorded price:"),
                  SizedBox(width: 10),
                  Text("-${gameVM.game.game.currentpercent}%"),
                  SizedBox(width: 10),
                  Price(price: gameVM.game.game.currentprice),
                ],
              ),
              Text(gameVM.game.game.shortdesc),
              SizedBox(height: 10),
              ListenableBuilder(
                listenable: gameVM,
                builder: (BuildContext context, Widget? child) {
                  if (gameVM.game.subscription != null) {
                    return Card(
                      child: Column(
                        children: [
                          (gameVM.game.subscription!.type ==
                                  SubscriptionType.dollar)
                              ? Row(
                                  children: [
                                    Text(
                                      "You will be notified when this game drops below ",
                                    ),
                                    Price(
                                      price: gameVM
                                          .game
                                          .subscription!
                                          .dollarthreshold!,
                                    ),
                                  ],
                                )
                              : Text(
                                  "You will be notified when this game drops below -${gameVM.game.subscription!.percentthreshold}% discount",
                                ),
                          ElevatedButton(
                            onPressed: () {
                              gameVM.unsubscribe();
                            },
                            child: Text(
                              "Unsubscribe from notifications for this game",
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Card(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text("Create a notification threshold using "),
                              SizedBox(
                                width: 200,
                                child: DropdownMenu(
                                  initialSelection: SubscriptionType.dollar,
                                  dropdownMenuEntries: [
                                    DropdownMenuEntry(
                                      value: SubscriptionType.dollar,
                                      label: "Dollar Amount",
                                    ),
                                    DropdownMenuEntry(
                                      value: SubscriptionType.percent,
                                      label: "Percent Discount",
                                    ),
                                  ],
                                  onSelected: (type) {
                                    gameVM.setSubscriptionType(
                                      type ?? SubscriptionType.dollar,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          (gameVM.subscriptionType == SubscriptionType.dollar)
                              ? Row(
                                  children: [
                                    Text(
                                      "Notify me when this game drops below \$",
                                    ),
                                    SizedBox(
                                      width: 200,
                                      child: TextField(
                                        onChanged: (text) {
                                          gameVM.dollarInput = text;
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Text(
                                      "Notify me when this game drops below ",
                                    ),
                                    SizedBox(
                                      width: 200,
                                      child: TextField(
                                        onChanged: (text) {
                                          gameVM.percentInput = text;
                                        },
                                      ),
                                    ),
                                    Text("% discount"),
                                  ],
                                ),
                          ElevatedButton(
                            onPressed: () {
                              gameVM.subscribe();
                            },
                            child: Text("Create Notification Subscription"),
                          ),
                          Text(gameVM.errorMsg ?? ""),
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
