import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isTitleVisible = false;
  double _avatarSize = 120.0;
  double _minAvatarSize = 50.0;
  double _maxAvatarSize = 160.0;
  bool fullImage = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        double offset = _scrollController.offset;
        _isTitleVisible = offset > 100; // Title ko‘rinadigan joy
        _avatarSize = (_maxAvatarSize - offset).clamp(_minAvatarSize, _maxAvatarSize + _maxAvatarSize);
        if (offset < -150) {
          fullImage = true;
        } else if (offset > 100){
          fullImage = false;
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0, // Kattalashtirilgan balandlik
            pinned: true,
            backgroundColor: Colors.black,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                var top = constraints.biggest.height;
                var scaleFactor = (top - _minAvatarSize) / (_maxAvatarSize - _minAvatarSize);
                //print(scaleFactor);
                return FlexibleSpaceBar(
                  title: AnimatedOpacity(
                    opacity: _isTitleVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: const Text(
                      "Дилшоджон Хайдаров",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  background: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        width: fullImage ? Get.width : _avatarSize,
                        height: fullImage ? Get.height : _avatarSize,
                        child: Transform.scale(
                          scale: scaleFactor.clamp(0.0, 1.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(fullImage ? 100.0 : 300.0),
                            child: Image.network(
                              'https://www.cembhofmann.co.uk/wp-content/uploads/2021/12/Balancing.jpg',
                              height: fullImage ? Get.height : _avatarSize,
                              width: fullImage ? Get.width : _avatarSize,
                              fit: fullImage ?  BoxFit.none : BoxFit.cover
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        child: Opacity(
                          opacity: scaleFactor.clamp(0.0, 1.0),
                          child: Column(
                            children: [
                              Text('Дилшоджон Хайдаров', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                              SizedBox(height: 4),
                              Text('+998 99 534 03 13', style: TextStyle(color: Colors.white70))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  color: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      const Divider(color: Colors.grey),
                      _buildListTile(
                          icon: Icons.person, title: 'Profilim', onTap: () {}),
                      _buildListTile(
                          icon: Icons.account_balance_wallet,
                          title: 'Hamyon',
                          onTap: () {}),
                      _buildListTile(
                          icon: Icons.bookmark,
                          title: 'Saqlangan xabarlar',
                          onTap: () {}),
                      _buildListTile(
                          icon: Icons.call,
                          title: 'Oxirgi chaqiruvlar',
                          onTap: () {}),
                      _buildListTile(
                          icon: Icons.settings,
                          title: 'Sozlamalar',
                          onTap: () {}),
                      SizedBox(height: Get.height),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ListTile _buildListTile(
      {required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      onTap: onTap,
    );
  }
}


