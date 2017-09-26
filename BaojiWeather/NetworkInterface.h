//
//  NetworkInterface.h
//  BaojiWeather
//
//  Created by Tcy on 2017/2/16.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#ifndef NetworkInterface_h
#define NetworkInterface_h

#define qqAppId @"1106236424"

#define wbKey @"1325565015"
#define wbSecret @"3895040ecbba0155c1f31e8c5eea3bf8"
#define kRedirectURI    @"http://www.sina.com"

#define URLHOST @"http://61.150.127.155:5001"

#define UserRegisterUrl @"http://61.150.127.155:8081/bjserver/uds?"
#define UserInforUrl @"http://61.150.127.155:8081/bjserver/ucs?"
#define YujingUrl @"http://61.150.127.155:8081/bjserver/ws?"
#define RealWeatherUrl @"http://61.150.127.155:8081/bjserver/trs?"
#define ForTownUrl @"http://61.150.127.155:8081/bjserver/tfs?"
#define ForCityUrl @"http://61.150.127.155:8081/bjserver/cfs?"
#define NoticeUrl @"http://61.150.127.155:8081/bjserver/n_s_s"
#define WeatherInforUrl @"http://61.150.127.155:8081/bjserver/n_p_s?"
#define ChinaWeatherUrl @"http://e.weather.com.cn/d/city/citysearch.shtml?fromurl=index"
#define JSTJUrl @"http://61.150.127.155:8081/bjserver/trc?type=N2"
#define YBCXUrl @"http://61.150.127.155:8081/bjserver/view/country.html"
#define RYLUrl @"http://61.150.127.155:8081/bjserver/trc?type=N4"
#define AtmoSever @"http://61.150.127.155:8081/bjserver/as?"
#define AtmoDetail @"http://61.150.127.155:8081/bjserver/as?id=%@"
#define ParkRealUrl @"http://61.150.127.156:9009/Frame/pCurrent/current.asp?fac=%@"
#define SinceUrl @"http://61.150.127.155:8081/bjserver/travel?"
#define SpecialWeather @"http://61.150.127.155:8081/bjserver/sws"

#define EcoUrl1 @"http://www.bjnycyh.com/infor.php"
#define EcoUrl2 @"http://www.bjssyj.com/infor.php"
#define EcoUrl3 @"http://www.baojihb.gov.cn/list/?1_1.html"
#define EcoUrl4 @"http://sanwen8.cn/p/1d4CWyU.html"
#define EcoUrl5 @"http://cmgc.jschina.com.cn/system/2016/10/25/029892833.shtml"
#define EcoUrl6 @"http://www.sei.gov.cn/ShowArticle.asp?ArticleID=260423"

#define PersonUrl @"http://61.150.127.155:8081/bjserver/pi"



#define RemindUrl @"http://61.150.127.155:8081/akpublic/version?ver=ios"

#define MainCityNameUrl @"http://61.150.127.155:8081/akpublic/wf?"
#define WarningUrl @"http://61.150.127.155:8081/akpublic/warning?"
#define MainCityIdUrl @"http://61.150.127.155:8081/akpublic/life?cityid=%@"
#define webUrl1 @"http://61.150.127.155:8081/akpublic/html/meteorologicDisasters.htm"
#define webUrl2 @"http://61.150.127.155:8081/akpublic/html/floodDrought.htm"
#define webUrl3 @"http://61.150.127.155:8081/akpublic/html/geologicHazard.htm"
#define webUrl4 @"http://61.150.127.155:8081/akpublic/html/forestFire.htm"
#define webUrl5 @"http://61.150.127.155:8081/akpublic/html/theEarthquake.htm"
#define webUrl6 @"http://61.150.127.155:8081/akpublic/html/avianInfluenza.htm"
#define webUrl7 @"http://61.150.127.155:8081/akpublic/html/fire.htm"
#define baikeUrl @"http://wapbaike.baidu.com/item/%@"

#define MarkIamgeUrl @"http://61.150.127.155:8081/akpublic/fallrain?sel=img&hours=%@"

#define FallPageUrl @"http://61.150.127.155:8081/akpublic/TempOrWaterServlet?type=N2"
#define TemperturePageUrl @"http://61.150.127.155:8081/akpublic/TempOrWaterServlet?type=N3"

#define FallWithTimeUrl @"http://61.150.127.155:8081/akpublic/fallrain?sel=data&hours=%@"

#define FallPointlist @"http://61.150.127.155:8081/akpublic/fallrain?sel=rain_poit&hours=0"

#define FallPointDetail @"http://61.150.127.155:8081/akpublic/fallrain?sel=24data&site_id=%@"

#define AirQualityMainPage @"http://61.150.127.155:8081/akpublic/airqulity?type=2"
#define AirQualityDetail @"http://61.150.127.155:8081/akpublic/airqulity?"
#define RadarImageList @"http://61.150.127.155:8081/akpublic/c_r_img?sel=r&pos=one"
#define RadarsImageList @"http://61.150.127.155:8081/akpublic/c_r_img?sel=r&pos=more"
#define RadarImage @"http://61.150.127.155:8081/akpublic/radarsigle/%@"
#define RadarsImage @"http://61.150.127.155:8081/akpublic/radar/%@"
#define NearPoint @"http://61.150.127.155:8081/akpublic/n_p_s"
#define TownForecast @"http://61.150.127.155:8081/akpublic/baoji/country.html"
#define CommenSence @"http://61.150.127.155:8081/akpublic/baoji/country.html"
#define Yingji @"http://61.150.127.155:8081/akpublic/yjya/ak.html"
#define MeteorologicalLaw @"http://61.150.127.155:8081/akpublic/page/Meteorologicalregulations.html"
#define YujiSign @"http://61.150.127.155:8081/akpublic/page/qxzhyjxhjfygn.htm"
#define AddressBook @"http://61.150.127.155:8081/akpublic/disaster_prevention?"

#define QiXiang @"http://61.150.127.155:8081/akLedserver/PdfJosnServlet?"
#define PDFUrl @"http://61.150.127.155:8081/akLedserver/PdfWriteOutServlet?prentid=%@"

#define YJSignal @"http://61.150.127.155:8081/bjserver/wl?param=1"


#endif /* NetworkInterface_h */
