import 'package:flutter/material.dart';
import '../../Utils.dart';
import 'GameViewModel.dart';

class GameView extends StatelessWidget {
  const GameView({super.key, required this.gameVM});

  final GameViewModel gameVM;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        gameVM.goBackToWishlist(context);
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: ListView(
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
                SizedBox(height: 10),
                Image.network(gameVM.game.game.capsuleimgurl, scale: 0.7),
                SizedBox(height: 10),
                Text(gameVM.game.game.shortdesc),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Current price: "),
                    if (gameVM.game.game.currentpercent != 0)
                      Text("-${gameVM.game.game.currentpercent}%"),
                    SizedBox(width: 10),
                    Text(
                      Utils.intCentsToFomattedString(
                        gameVM.game.game.currentprice,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Best recorded price: "),
                    if (gameVM.game.game.bestrecordedpercent != 0)
                      Text("-${gameVM.game.game.bestrecordedpercent}%"),
                    SizedBox(width: 10),
                    Text(
                      Utils.intCentsToFomattedString(
                        gameVM.game.game.bestrecordedprice,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                SubscriptionSection(gameVM: gameVM),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SubscriptionSection extends StatelessWidget {
  final GameViewModel gameVM;

  const SubscriptionSection({required this.gameVM});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: gameVM,
      builder: (BuildContext context, Widget? child) {
        if (gameVM.game.subscription != null) {
          return CurrentSubscriptionSection(gameVM: gameVM);
        } else {
          return NewSubscriptionSection(gameVM: gameVM);
        }
      },
    );
  }
}

class CurrentSubscriptionSection extends StatelessWidget {
  final GameViewModel gameVM;

  const CurrentSubscriptionSection({required this.gameVM});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          (gameVM.game.subscription!.type == SubscriptionType.dollar)
              ? Text(
                  "You will be notified when this game drops below ${Utils.intCentsToFomattedString(gameVM.game.subscription!.dollarthreshold!)}",
                  textAlign: TextAlign.center,
                )
              : Text(
                  "You will be notified when this game drops below -${gameVM.game.subscription!.percentthreshold}% discount",
                  textAlign: TextAlign.center,
                ),
          ElevatedButton(
            onPressed: () {
              gameVM.unsubscribe();
            },
            child: Text("Unsubscribe from notifications for this game"),
          ),
        ],
      ),
    );
  }
}

class NewSubscriptionSection extends StatelessWidget {
  final GameViewModel gameVM;

  const NewSubscriptionSection({required this.gameVM});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
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
                gameVM.setSubscriptionType(type ?? SubscriptionType.dollar);
              },
            ),
          ),
          (gameVM.subscriptionType == SubscriptionType.dollar)
              ? Column(
                  children: [
                    Text("Notify me when this game drops below"),
                    SizedBox(
                      width: 50,
                      child: TextField(
                        decoration: InputDecoration(prefixText: "\$"),
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onChanged: (text) {
                          gameVM.dollarInput = text;
                        },
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Text("Notify me when this game drops below "),
                    SizedBox(
                      width: 50,
                      child: TextField(
                        decoration: InputDecoration(
                          prefixText: "-",
                          suffixText: "%",
                        ),
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: false,
                        ),
                        onChanged: (text) {
                          gameVM.percentInput = text;
                        },
                      ),
                    ),
                  ],
                ),
          ElevatedButton(
            onPressed: () {
              gameVM.subscribe();
            },
            child: Text("Create Notification Subscription"),
          ),
          Text(gameVM.errorMsg ?? "", style: TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}
