import 'package:flutter/material.dart';
import 'package:watched_it/pages/to_watch_screen.dart';
import 'package:watched_it/pages/watched_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Watched It ?',
          style: TextStyle(
            fontSize: 26.0,
            fontFamily: 'Montserrat',
            letterSpacing: 1.3,
            color: Theme.of(context).primaryColor,
          ),
        ),
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.all(10.0),
                  color: Colors.white,
                  child: DefaultTabController(
                    length: 2,
                    initialIndex: 0,
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.black54,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: CircleTabIndicator(
                          color: Theme.of(context).primaryColor, radius: 3),
                      labelPadding: EdgeInsets.all(15.0),
                      isScrollable: true,
                      labelStyle: TextStyle(
                        fontSize: 18.0,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'NunitoSans',
                      ),
                      labelColor: Colors.black87,
                      unselectedLabelStyle: TextStyle(
                        fontSize: 18.0,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'NunitoSans',
                      ),
                      unselectedLabelColor: Colors.black38,
                      tabs: [
                        Text('To Watch'),
                        Text('Watched'),
                      ],
                      onTap: (index) {},
                    ),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: TabBarView(
                controller: _tabController,
                children: [
                  ToWatchScreen(),
                  WatchedScreen(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CircleTabIndicator extends Decoration {
  final BoxPainter _painter;

  CircleTabIndicator({@required Color color, @required double radius})
      : _painter = _CirclePainter(color, radius);

  @override
  BoxPainter createBoxPainter([onChanged]) => _painter;
}

class _CirclePainter extends BoxPainter {
  final Paint _paint;
  final double radius;

  _CirclePainter(Color color, this.radius)
      : _paint = Paint()
          ..color = color
          ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Offset circleOffset =
        offset + Offset(cfg.size.width / 2, cfg.size.height - radius);
    canvas.drawCircle(circleOffset, radius, _paint);
  }
}
