import 'package:ampedmedia_flutter/model/materialmodel.dart';
import 'package:ampedmedia_flutter/provider/books.dart';
import 'package:ampedmedia_flutter/provider/materialcreationprovider.dart';
import 'package:ampedmedia_flutter/url.dart';
import 'package:ampedmedia_flutter/view/detailview/bookdetailview.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AllMagazine extends StatefulWidget {
  static final routeName = '/AllMagazine';
  const AllMagazine({super.key});

  @override
  State<AllMagazine> createState() => _AllMagazineState();
}

class _AllMagazineState extends State<AllMagazine> {
  late Future<List<MaterialModel>> materialList;
  String? token;
  @override
  void didChangeDependencies() {
    print('get top books info display didchangedepcey ...........');
    materialList = Provider.of<materialCreationProvider>(context, listen: false)
        .getMaterialByType('Magazine');
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Books booksObject = Provider.of<Books>(context);
    var appBar = AppBar(
      leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          )),
      backgroundColor: Colors.white,
      elevation: 0.5,
      actions: [
        // Image(image: AssetImage('assets/images/filter.png')),
        // Image(image: AssetImage('assets/images/Notification.png')),
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Text(
              'Magazines',
              style: TextStyle(color: Colors.black, fontSize: 24),
            ),
          ),
          Expanded(
              child: FutureBuilder(
            future: materialList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.5 / 2,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            BookDetailView(book: snapshot.data![index]),
                      ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(5)),
                      // height: 500,
                      // width: 132,

                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(5)),
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        height: 220,
                        width: 132,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 124,
                              child: Image(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      headers: {},
                                      '${BackEndUrl.url}/material/material_cover/${snapshot.data![index].material_image}')),
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                top: 1,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Text(
                                      '${snapshot.data![index].title}',
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text('${snapshot.data![index].title}'),
                            Text('${snapshot.data![index].publisher}'),
                            Text('${snapshot.data![index].price} birr'),
                            Text(
                              '${DateFormat('dd-MM-yyyy').format(DateTime.parse(snapshot.data![index].created_at))}',
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    heightFactor: 10,
                    widthFactor: 10,
                    child: CircularProgressIndicator());
              }
              return Center(
                  heightFactor: 10,
                  widthFactor: 10,
                  child: Text('Please try later'));
            },
          )),
        ],
      ),
    );
  }
}