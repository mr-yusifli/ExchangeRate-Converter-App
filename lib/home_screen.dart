import 'package:flutter/cupertino.dart';
import 'package:mycurrencyapp/models/country.dart';
import 'package:flutter/material.dart';
import 'package:mycurrencyapp/repository/convert_repository.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Country fromCountry = datas[0];
  Country toCountry = datas[1];
  double value = 1;
  late Future<double> resFuture;

  @override
  void initState() {
    super.initState();
    _requestConvert();
  }

  _requestConvert() {
    resFuture = ConvertRepo().convert(
        fromCurr: fromCountry.currency,
        toCurr: toCountry.currency,
        value: value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Valyuta Konvertoru",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            _buildCurrencyView(fromCountry, false),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      '=',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      final temp = fromCountry;
                      fromCountry = toCountry;
                      toCountry = temp;
                      _requestConvert();
                    });
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.indigo[50],
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.indigo)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(children: [
                        Image.asset(
                          'assets/images/switch.png',
                          height: 35,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        const Text(
                          'Valyutaları dəyişdirin',
                          style: TextStyle(
                              color: Colors.indigo,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        )
                      ]),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            FutureBuilder<double>(
                future: resFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return _buildCurrencyView(toCountry, true,
                        res: snapshot.data);
                  }
                  return SizedBox.shrink();
                }),
          ],
        ),
      ),
    );
  }

  Container _buildCurrencyView(Country country, bool isDestination,
      {double? res}) {
    final formattedRes = NumberFormat.currency(
      locale: 'en_US',
      symbol: '',
      decimalDigits: 2,
    ).format(res ?? 0.0);

    return Container(
      height: 170,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 4,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            InkWell(
              onTap: () => _buildMenuCurrency(isDestination),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadiusDirectional.circular(5),
                    child: Image.network(
                      country.urlFlag,
                      height: 30,
                      width: 50,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          country.name,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          country.currency,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            TextFormField(
              key: isDestination ? Key(formattedRes) : Key(value.toString()),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              initialValue: isDestination ? formattedRes : value.toString(),
              onFieldSubmitted: (val) {
                if (double.parse(val) != null) {
                  setState(() {
                    value = double.parse(val);
                    _requestConvert();
                  });
                }
              },
              maxLength: 5,
              decoration: InputDecoration(
                hintText: '0.0',
                enabled: !isDestination,
                suffixIcon: Text(
                  country.currency,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),
                suffixIconConstraints: const BoxConstraints(
                  minWidth: 0,
                  minHeight: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildMenuCurrency(bool isDestination) {
    showCupertinoModalPopup(
        context: context,
        builder: (_) => CupertinoActionSheet(
              actions: _buildListActions(onPressed: (index) {
                setState(() {
                  isDestination
                      ? toCountry = datas[index]
                      : fromCountry = datas[index];
                  _requestConvert();
                  Navigator.pop(context);
                });
              }),
              cancelButton: CupertinoActionSheetAction(
                child: Text('Bağla'),
                isDestructiveAction: true,
                onPressed: () => Navigator.pop(context),
              ),
            ));
  }

  List<Widget> _buildListActions({void Function(int)? onPressed}) {
    var listActions = <Widget>[];
    for (var i = 0; i < datas.length; i++) {
      listActions.add(CupertinoActionSheetAction(
        onPressed: onPressed != null ? () => onPressed(i) : () {},
        child: Row(
          children: [
            Image.network(
              datas[i].urlFlag,
              height: 30,
              width: 30,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 8),
            Text(datas[i].name),
          ],
        ),
      ));
    }
    return listActions;
  }
}
