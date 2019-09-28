import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';

const List<double> fontSizeList = [25.0, 20.0, 18.0, 15.0, 10.0];

///
///Função Responsividade => Largura
///

responsiveWidth(double value, BuildContext context) {
  double result = (MediaQuery.of(context).size.width / 100) * value;
  return result;
}

///
///Função Responsividade => Altura
///

responsiveHeight(double value, BuildContext context) {
  double result = (MediaQuery.of(context).size.height / 100) * value;
  return result;
}

class AssetGifDialog extends StatelessWidget {
  /// Gif Dialog - Asset
  /// 
  /// ```dart
  /// AssetGifDialog(
  ///   gif: "https://media0.giphy.com/media/wKC0Icp9Nwr5K/giphy.gif",
  ///   message: "Confirmar conclusão?",
  ///   statusOkButton: true,
  ///   textOkButtonIntl: "Sim",
  ///   fontSizeOkButtonIntl: [20], 
  ///   textCloseButtonIntl: "Não",
  ///   fontSizeCloseButtonIntl: [20],
  ///   pressedOkButton: (){},
  ///   cornerRadius: 10.0
  /// );
  /// ```
  /// 
  const AssetGifDialog({
    Key key,
    @required this.gif,
    @required this.message,
    this.fontSizeMessageIntl,

    this.statusOkButton = false,
    this.pressedOkButton,

    this.textCloseButtonIntl,
    this.fontSizeCloseButtonIntl = fontSizeList,

    this.textOkButtonIntl,
    this.fontSizeOkButtonIntl = fontSizeList,
    
    this.cornerRadius = 10.0,
    this.fitGif
  }) : super(key: key);

  final String gif;
  final String message;
  final List<double> fontSizeMessageIntl;

  final bool statusOkButton;
  final VoidCallback pressedOkButton;

  final String textCloseButtonIntl;
  final List<double> fontSizeCloseButtonIntl;
  final String textOkButtonIntl;
  final List<double> fontSizeOkButtonIntl;

  final double cornerRadius;
  final BoxFit fitGif;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: responsiveHeight(24, context),
        bottom: responsiveHeight(24, context),
        left: responsiveWidth(17, context),
        right: responsiveWidth(17, context)
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(cornerRadius)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: responsiveHeight(20, context),
              width: responsiveWidth(50, context),
              child: Card(
                elevation: 0.0,
                margin: EdgeInsets.all(0.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    topLeft: Radius.circular(8)
                  )
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  this.gif,
                  fit: fitGif,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15
              ),
              child: Material(
                type: MaterialType.transparency,
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black54
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                (statusOkButton != false ?
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: RaisedButton(
                      color: Colors.teal[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)
                      ),
                      onPressed: pressedOkButton ?? () {},
                      child: Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: AutoSizeText(
                          textOkButtonIntl == null ? 'Ok' : textOkButtonIntl,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: fontSizeOkButtonIntl.first
                          ),
                          presetFontSizes: fontSizeOkButtonIntl == null ? fontSizeList : fontSizeOkButtonIntl,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                )
                :
                Container()
                ),
                (statusOkButton != false ? Spacer( flex: 1) : Container()),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: RaisedButton(
                      color: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: AutoSizeText(
                          textCloseButtonIntl == null ? 'Fechar' : textCloseButtonIntl,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: fontSizeCloseButtonIntl.first
                          ),
                          presetFontSizes: fontSizeCloseButtonIntl == null ? fontSizeList : fontSizeCloseButtonIntl,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}