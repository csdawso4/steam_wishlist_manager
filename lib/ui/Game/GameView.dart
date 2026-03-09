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
                      Image.network(gameVM.game.capsuleimgurl),
                      SizedBox(width: 10),
                      Text(gameVM.game.name),
                    ],
                  ),
                  Row(
                    children: [
                      if (gameVM.game.currentpercent != 0)
                        Text("-${gameVM.game.currentpercent}%"),
                      SizedBox(width: 10),
                      Price(price: gameVM.game.currentprice),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Text("Best recorded price:"),
                  SizedBox(width: 10),
                  Text("-${gameVM.game.currentpercent}%"),
                  SizedBox(width: 10),
                  Price(price: gameVM.game.currentprice),
                ],
              ),
              Text(gameVM.game.shortdesc),
              SizedBox(height: 10),
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
              ListenableBuilder(
                listenable: gameVM,
                builder: (BuildContext context, Widget? child) {
                  if (gameVM.subscriptionType == SubscriptionType.dollar) {
                    return Row(
                      children: [
                        Text("Notify me when this game drops below \$"),
                        SizedBox(width: 200, child: TextField(onChanged: (text) {gameVM.dollarInput = text;}))
                      ],
                    );
                  } else {
                    return Row(
                      children: [
                        Text("Notify me when this game drops below "),
                        SizedBox(width: 200, child: TextField(onChanged: (text) {gameVM.percentInput = text;})),
                        Text("% discount"),
                      ],
                    );
                  }
                },
              ),
              ElevatedButton(
                onPressed: () {
                  gameVM.subscribe();
                },
                child: Text("Create Notification Subscription"),
              ),
              ListenableBuilder(
                listenable: gameVM,
                builder: (BuildContext context, Widget? child) {
                  return Text(gameVM.errorMsg ?? "");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
