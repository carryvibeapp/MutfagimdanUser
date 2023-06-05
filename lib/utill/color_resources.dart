import 'package:flutter/material.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class ColorResources {
  static Color getGreyColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF6f7275) : Color(0xFFA0A4A8);
  }
  static Color getGrayColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF919191) : Color(0xFF6E6E6E);
  }
  static Color getSearchBg(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF585a5c) : Color(0xFFF4F7FC);
  }
  static Color getBackgroundColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF343636) : Color(0xFFF4F7FC);
  }
  static Color getHintColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF98a1ab) : Color(0xFF52575C);
  }
  static Color getGreyBunkerColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFE4E8EC) : Color(0xFF25282B);
  }
  static Color getWhiteAndBlack(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? COLOR_WHITE : COLOR_BLACK;
  }
  static Color getBlackAndWhite(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? COLOR_BLACK : COLOR_WHITE;
  }

  static Color getCartTitleColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ?  Color(0xFF61699b) : Color(0xFF000743);
  }
  static Color getCartColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ?  Color(0xFF494949) : Color(0xFFFFFFFF);
  }
  static Color getCategoryHoverColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ?  Color(0xFF6490ee) : Color(0xFFC5DCFA);
  } 
  static Color getHomeSearchBarColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ?  Color(0xFFb2b8bd) : Color(0xFFE4EAEF);
  }
  static Color getTextTitleColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ?  Color(0xFFFFFFFF) : Color(0xFF000000);
  }
  static Color getProfileMenuHeaderColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ?  FOOTER_COL0R.withOpacity(0.5) : FOOTER_COL0R;
  }
  static Color getFooterColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ?  Color(0xFF494949) :Color(0xFFFFDDD9);
  }
  static Color getChatAdminColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ?  Color(0xFFa1916c) :Color(0xFFFFDDD9);
  }


  static const Color COLOR_GREY = Color(0xFFA0A4A8);
  static const Color COLOR_BLACK = Color(0xFF000000);
  static const Color COLOR_NERO = Color(0xFF1F1F1F);
  static const Color COLOR_WHITE = Color(0xFFFFFFFF);
  static const Color COLOR_HINT = Color(0xFF52575C);
  static const Color SEARCH_BG = Color(0xFFF4F7FC);
  static const Color COLOR_GRAY = Color(0xff6E6E6E);
  static const Color COLOR_OXFORD_BLUE = Color(0xff282F39);
  static const Color COLOR_GAINSBORO = Color(0xffE8E8E8);
  static const Color COLOR_NIGHER_RIDER = Color(0xff303030);
  static const Color BACKGROUND_COLOR = Color(0xffF4F7FC);
  static const Color COLOR_GREY_BUNKER = Color(0xff25282B);
  static const Color COLOR_GREY_CHATEAU = Color(0xffA0A4A8);
  static const Color BORDER_COLOR = Color(0xFFDCDCDC);
  static const Color DISABLE_COLOR = Color(0xFF979797);
  static const Color APPBAR_HEADER_COL0R = Color(0xFFFC6A57);
  static const Color FOOTER_COL0R = Color(0xFFFFDDD9);
  static const Color ARROW_COLOR = Color(0xFF515755);
  static const Color FOOTER_BODY_TEXT_COLOR = Color(0xFF454545);
  static const Color MENU = Color(0xFF454545);
  static const Color CARD_SHADOW_COLOR = Color(0xFFA7A7A7);
 // static const Color CATEGORIES_HOVER_COLOR = Color(0xFFC5DCFA);

  static const Map<int, Color> colorMap = {
    50: Color(0x10192D6B),
    100: Color(0x20192D6B),
    200: Color(0x30192D6B),
    300: Color(0x40192D6B),
    400: Color(0x50192D6B),
    500: Color(0x60192D6B),
    600: Color(0x70192D6B),
    700: Color(0x80192D6B),
    800: Color(0x90192D6B),
    900: Color(0xff192D6B),
  };

}
