
import 'package:forestvpn_huawei_ads/adslite/ad_param.dart';
import 'package:forestvpn_huawei_ads/adslite/banner/banner_ad.dart';
import 'package:forestvpn_huawei_ads/adslite/banner/banner_ad_size.dart';
import 'package:forestvpn_huawei_ads/adslite/interstitial/interstitial_ad.dart';
import 'package:forestvpn_huawei_ads/adslite/reward/reward_ad.dart';

BannerAd createAd() {
  return BannerAd(
    adSlotId: 'z9vrvpnrn9',
    size: BannerAdSize.s728x90,
    adParam: AdParam(),
  );
}
// InterstitialAd createAdInteritial() {
//   return InterstitialAd(
//     // adSlotId: "teste9ih9j0rc3",
//    adSlotId: "x2764fmoix",
//     adParam: AdParam(),
//   );
// }
InterstitialAd createAdHms() {
  return InterstitialAd(
    //adSlotId: "teste9ih9j0rc3",
        adSlotId: "q7zz0xsy5p",
    adParam: AdParam(),
  );
}
