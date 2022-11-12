
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:newflutterapp/models/sql_db.dart';

import 'add_note.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _controller;

  bool isLoaded = false;
  SQLDB db = SQLDB();
  List<Map<dynamic, dynamic>> notes = [];
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  Future<void> GetLatestNotes() async {
    notes = await db.readData();
    notes = notes.reversed.toList();
    setState(() {});
  }

  @override
  didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    notes = await db.readData();
    notes = notes.reversed.toList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addListener(() {
      if (_controller.value > 0.7) {
        isLoaded = true;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Column(
              children: [
                const MyAppBar(),
                SearchBar(width: width),
                const SizedBox(height: 10),
                DisplayNotes(
                  height: height,
                  notes: notes,GetLatestNotes: GetLatestNotes,
                ),
              ],
            ),
            Positioned(
                width: 60,
                height: 60,
                bottom: 15,
                right: 15,
                child: FloatingActionButton(
                  onPressed: () async {
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddNote(),
                      ),
                    );
                    if (result as String == "added") {
                      GetLatestNotes();
                    }
                  },
                  backgroundColor: Colors.orange,
                  child: const Icon(
                    Icons.add,
                    size: 40,
                  ),
                )),
            AnimatedSplash(
                isLoaded: isLoaded, height: height, controller: _controller),
          ],
        ),
      ),
    );
  }
}

class DisplayNotes extends StatefulWidget {
  double? height;
  Function? GetLatestNotes;
  DisplayNotes({this.GetLatestNotes,this.notes, this.height});
  List<Map<dynamic, dynamic>>? notes;

  @override
  State<DisplayNotes> createState() => _DisplayNotesState();
}

class _DisplayNotesState extends State<DisplayNotes> {
  SQLDB db = SQLDB();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height! * 0.80,
      child: GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: widget.notes!.length,
        itemBuilder: (BuildContext context, int index) {
          
          return GestureDetector(
            onTap: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddNote.update(
                      id: widget.notes![index]["id"],
                      body: widget.notes![index]["note"],
                      title: widget.notes![index]["title"]),
                ),
              );
              if (result as String == "added") {
                
                widget.GetLatestNotes!();
              }
            },
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex:1,
                    child: Text(
                      widget.notes![index]["title"] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    flex:3,
                    child: Text(
                      widget.notes![index]["note"] as String,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey, fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Expanded(
                    flex:1,
                    child:Text(
                      "June 1",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                ],
              ),
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: const Color(0xff242424),
                  borderRadius: BorderRadius.circular(20)),
            ),
          );
        },
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width - 25,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: const TextField(
        enabled: false,
        style: TextStyle(fontSize: 20),
        decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          hintText: "Search Notes",
          icon: Icon(
            Icons.search,
            size: 25,
            color: Colors.grey,
          ),
        ),
      ),
      decoration: BoxDecoration(
        color: const Color(0xff141414),
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}

class MyAppBar extends StatelessWidget {
  const MyAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 80,
              ),
              IconButton(
                  onPressed: () {},
                  iconSize: 25,
                  icon: const Icon(Icons.book),
                  color: Colors.orange),
              const SizedBox(
                width: 20,
              ),
              IconButton(
                  onPressed: () {},
                  iconSize: 25,
                  icon: const Icon(Icons.check_box_outlined),
                  color: Colors.grey),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: IconButton(
            onPressed: () {},
            iconSize: 25,
            icon: const Icon(Icons.list_rounded),
            color: Colors.grey,
          ),
        )
      ],
    );
  }
}

class AnimatedSplash extends StatelessWidget {
  const AnimatedSplash({
    Key? key,
    required this.isLoaded,
    required this.height,
    required AnimationController controller,
  })  : _controller = controller,
        super(key: key);

  final bool isLoaded;
  final double height;
  final AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      height: isLoaded ? 0.0 : height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xff141414),
        borderRadius: isLoaded
            ? const BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25))
            : null,
      ),
      child: AnimatedOpacity(
        duration: const Duration(seconds: 2),
        opacity: isLoaded ? 0 : 1,
        child: Center(
          child: Lottie.asset(
            "assets/animation/76111-notepad.json",
            height: 250,
            controller: _controller,
            onLoaded: (composition) {
              _controller.duration = composition.duration;
              _controller.forward();
            },
          ),
        ),
      ),
    );
  }
}
