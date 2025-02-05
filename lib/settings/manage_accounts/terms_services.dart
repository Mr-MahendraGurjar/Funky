import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_html_css/simple_html_css.dart';

import '../../homepage/controller/homepage_controller.dart';

class Temrs_servicesScreen extends StatefulWidget {
  const Temrs_servicesScreen({Key? key}) : super(key: key);

  @override
  State<Temrs_servicesScreen> createState() => _Temrs_servicesScreenState();
}

class _Temrs_servicesScreenState extends State<Temrs_servicesScreen> {
  final HomepageController homepageController = Get.put(HomepageController(), tag: HomepageController().toString());

  @override
  void initState() {
    homepageController.getTermsService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextSpan textSpan = HTML.toTextSpan(
      context,
      homepageController.termsServiceModel?.data?.content ?? "",
      linksCallback: (dynamic link) {
        debugPrint('You clicked on ${link.toString()}');
      },
      // as name suggests, optionally set the default text style
      defaultTextStyle: TextStyle(
        color: Colors.grey[700],
      ),

      overrideStyle: <String, TextStyle>{
        'p': TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontFamily: 'PR',
            fontWeight: FontWeight.w200,
            decoration: TextDecoration.none),
        // FontStyleUtility.h16(
        //     fontColor: ColorUtils.primary_grey,
        //     family: 'PR'),
        'a': const TextStyle(wordSpacing: 2),
        // specify any tag not just the supported ones,
        // and apply TextStyles to them and/override them
      },
    );
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Terms of service',
          style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PB'),
        ),
        centerTitle: true,
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.only(
            right: 20.0,
            top: 0.0,
            bottom: 5.0,
          ),
          child: ClipRRect(
              child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          )),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Obx(() => homepageController.istermsServiceLoading.value == true
                      ? SizedBox()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 19.0),
                          child: RichText(
                              text: /*textSpan*/ HTML.toTextSpan(
                            context,
                            homepageController.termsServiceModel?.data?.content ?? "",
                            linksCallback: (dynamic link) {
                              debugPrint('You clicked on ${link.toString()}');
                            },
                            // as name suggests, optionally set the default text style
                            defaultTextStyle: TextStyle(
                              color: Colors.grey[700],
                            ),

                            overrideStyle: <String, TextStyle>{
                              'p': TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontFamily: 'PR',
                                  fontWeight: FontWeight.w200,
                                  decoration: TextDecoration.none),
                              // FontStyleUtility.h16(
                              //     fontColor: ColorUtils.primary_grey,
                              //     family: 'PR'),
                              'a': const TextStyle(wordSpacing: 2),
                              // specify any tag not just the supported ones,
                              // and apply TextStyles to them and/override them
                            },
                          )),
                        )

                  // Html(
                  //         anchorKey: GlobalKey(),
                  //         data: ,
                  //         // data: "<h5>check 1<\/p>\r\n",
                  //         style: {
                  //           "body": Style(
                  //             // backgroundColor: const Color.fromARGB(
                  //             //     0x50, 0xee, 0xee, 0xee),
                  //             backgroundColor:
                  //                 Colors.transparent,
                  //           ),
                  //           "tr": Style(
                  //             border: const Border(
                  //                 bottom: BorderSide(
                  //                     color: Colors.grey)),
                  //           ),
                  //           "th": Style(
                  //             padding:
                  //                 const EdgeInsets.all(6),
                  //             backgroundColor: Colors.grey,
                  //           ),
                  //           "td": Style(
                  //             padding:
                  //                 const EdgeInsets.all(6),
                  //             alignment: Alignment.topLeft,
                  //           ),
                  //           'p': Style(
                  //               // maxLines: 2,
                  //               color: Colors.red,
                  //               textOverflow:
                  //                   TextOverflow.ellipsis),
                  //         },
                  //       )
                  ),
              // Container(
              //   child: Container(
              //     child: const Text(
              //       "TERMS OF SERVICES"
              //       "Last updated: 21/01/2023"
              //       "Introduction"
              //       "Welcome to Funky Pte. Ltd. (“Company”, “we”, “our”, “us”, “Funky”)!"
              //       "These Terms of Service (“Terms”, “Terms of Service”) govern your use of our website located at www.funky.global. (together or individually “Service”) operated by Funky Pte. Ltd."
              //       "Our Privacy Policy also governs your use of our Service and explains how we collect, safeguard and disclose information that results from your use of our web pages."
              //       "Your agreement with us includes these Terms and our Privacy Policy (“Agreements”). You acknowledge that you have read and understood Agreements, and agree to be bound of them."
              //       "If you do not agree with (or cannot comply with) Agreements, then you may not use the Service, but please let us know by emailing at support@funky.global so we can try to find a solution. These Terms apply to all visitors, users and others who wish to access or use Service."
              //       "Supplemental Terms"
              //       "If you access or use the Services from within a jurisdiction for which there are separate supplemental terms, you also hereby agree to the supplemental terms applicable to users in each jurisdiction as outlined in the relevant “Supplemental Terms – Jurisdiction Specific” section below. In the event of a conflict between the provisions of the Supplemental Terms – Jurisdiction Specific that are relevant to your jurisdiction from which you access or use the Services, and the rest of these Terms, the relevant jurisdiction’s Supplemental Terms – Jurisdiction Specific will supersede and control with respect to your use of the Services from that jurisdiction."
              //       "Communications"
              //       "By using our Service, you agree to subscribe to newsletters, marketing or promotional materials and other information we may send. However, you may opt out of receiving any, or all, of these communications from us by following the unsubscribe link or by emailing at support@funky.global"
              //       "Contests, Sweepstakes and Promotions"
              //       "Any contests, sweepstakes or other promotions (collectively, “Promotions”) made available through Service may be governed by rules that are separate from these Terms of Service. If you participate in any Promotions, please review the applicable rules as well as our Privacy Policy. If the rules for a Promotion conflict with these Terms of Service, Promotion rules will apply."
              //       "Content"
              //       "Our Service allows you to post, link, store, share and otherwise make available certain information, text, graphics, videos, or other material (“Content”). You are responsible for Content that you post on or through Service, including its legality, reliability, and appropriateness."
              //       "By posting Content on or through Service, You represent and warrant that: (i) Content is yours (you own it) and/or you have the right to use it and the right to grant us the rights and license as provided in these Terms, and (ii) that the posting of your Content on or through Service does not violate the privacy rights, publicity rights, copyrights, contract rights or any other rights of any person or entity. We reserve the right to terminate the account of anyone found to be infringing on a copyright."
              //       "You retain any and all of your rights to any Content you submit, post or display on or through Service and you are responsible for protecting those rights. We take no responsibility and assume no liability for Content you or any third party posts on or through Service. However, by posting Content using Service you grant us the right and license to use, modify, publicly perform, publicly display, reproduce, and distribute such Content on and through Service. You agree that this license includes the right for us to make your Content available to other users of Service, who may also use your Content subject to these Terms."
              //       "Funky Pte. Ltd. has the right but not the obligation to monitor and edit all Content provided by users."
              //       "In addition, Content found on or through this Service are the property of Funky Pte. Ltd. or used with permission. You may not distribute, modify, transmit, reuse, download, repost, copy, or use said Content, whether in whole or in part, for commercial purposes or for personal gain, without express advance written permission from us."
              //       "Prohibited Uses"
              //       "You may use Service only for lawful purposes and in accordance with Terms. You agree not to use Service:"
              //       "6.1 In any way that violates any applicable national or international law or regulation."
              //       "6.2. For the purpose of exploiting, harming, or attempting to exploit or harm minors in any way by exposing them to inappropriate content or otherwise."
              //       "6.3. To transmit, or procure the sending of, any advertising or promotional material, including any “junk mail”, “chain letter,” “spam,” or any other similar solicitation."
              //       "6.4. To impersonate or attempt to impersonate Company, a Company employee, another user, or any other person or entity."
              //       "6.5. In any way that infringes upon the rights of others, or in any way is illegal, threatening, fraudulent, or harmful, or in connection with any unlawful, illegal, fraudulent, or harmful purpose or activity."
              //       "6.6. To engage in any other conduct that restricts or inhibits anyone’s use or enjoyment of Service, or which, as determined by us, may harm or offend Company or users of Service or expose them to liability."
              //       "Additionally, you agree not to:"
              //       "(a)   Use Service in any manner that could disable, overburden, damage, or impair Service or interfere with any other party’s use of Service, including their ability to engage in real time activities through Service."
              //       "(b)   Use any robot, spider, or other automatic device, process, or means to access Service for any purpose, including monitoring or copying any of the material on Service."
              //       "(c)   Use any manual process to monitor or copy any of the material on Service or for any other unauthorized purpose without our prior written consent."
              //       "(d)   Use any device, software, or routine that interferes with the proper working of Service."
              //       "(e)  Introduce any viruses, trojan horses, worms, logic bombs, or other material which is malicious or technologically harmful."
              //       "(f)   Attempt to gain unauthorized access to, interfere with, damage, or disrupt any parts of Service, the server on which Service is stored, or any server, computer, or database connected to Service."
              //       "(g)   Attack Service via a denial-of-service attack or a distributed denial-of-service attack."
              //       "(h)   Take any action that may damage or falsify Company rating."
              //       "(i)     Otherwise attempt to interfere with the proper working of Service."
              //       "Analytics"
              //       "We may use third-party Service Providers to monitor and analyze the use of our Service."
              //       "No Use By Minors"
              //       "Service is intended only for access and use by individuals at least eighteen (18) years old. By accessing or using Service, you warrant and represent that you are at least eighteen (18) years of age and with the full authority, right, and capacity to enter into this agreement and abide by all of the terms and conditions of Terms. If you are not at least eighteen (18) years old, you are prohibited from both the access and usage of Service."
              //       "Accounts"
              //       "When you create an account with us, you guarantee that you are above the age of 18, and that the information you provide us is accurate, complete, and current at all times. Inaccurate, incomplete, or obsolete information may result in the immediate termination of your account on Service."
              //       "You are responsible for maintaining the confidentiality of your account and password, including but not limited to the restriction of access to your computer and/or account. You agree to accept responsibility for any and all activities or actions that occur under your account and/or password, whether your password is with our Service or a third-party service. You must notify us immediately upon becoming aware of any breach of security or unauthorized use of your account."
              //       "You may not use as a username the name of another person or entity or that is not lawfully available for use, a name or trademark that is subject to any rights of another person or entity other than you, without appropriate authorization. You may not use as a username any name that is offensive, vulgar or obscene."
              //       "We reserve the right to refuse service, terminate accounts, remove or edit content, or cancel orders in our sole discretion."
              //       "Intellectual Property"
              //       "Service and its original content (excluding Content provided by users), features and functionality are and will remain the exclusive property of Funky Pte. Ltd. and its licensors. Service is protected by copyright, trademark, and other laws of and foreign countries. Our trademarks may not be used in connection with any product or service without the prior written consent of Funky Pte Ltd. Users are not allowed to reproduce,modify,edit,repost or any other means re-use the original User’s content to earn shares. Funky has all reserves the rights to not pay for such act."
              //       "Copyright Policy"
              //       "We respect the intellectual property rights of others. It is our policy to respond to any claim that Content posted on Service infringes on the copyright or other intellectual property rights (“Infringement”) of any person or entity."
              //       "If you are a copyright owner, or authorized on behalf of one, and you believe that the copyrighted work has been copied in a way that constitutes copyright infringement, please submit your claim via email to support@funky.global, with the subject line: “Copyright Infringement” and include in your claim a detailed description of the alleged Infringement as under “Notice and Procedure for Copyright Infringement Claims” or any other similar permissable law applicable and updated time to time."
              //       "You may be held accountable for damages (including costs and attorneys’ fees) for misrepresentation or bad-faith claims on the infringement of any Content found on and/or through Service on your copyright."
              //       "DMCA Notice and Procedure for Copyright Infringement Claims (US)"
              //       "You may submit a notification pursuant to the Digital Millennium Copyright Act (DMCA) by providing our Copyright Agent with the following information in writing (see 17 U.S.C 512(c)(3) for further detail):"
              //       "12.1.  an electronic or physical signature of the person authorized to act on behalf of the owner of the copyright’s interest;"
              //       "12.2. a description of the copyrighted work that you claim has been infringed, including the URL (i.e., web page address) of the location where the copyrighted work exists or a copy of the copyrighted work;"
              //       "12.3. identification of the URL or other specific location on Service where the material that you claim is infringing is located;"
              //       "12.4. your address, telephone number, and email address;"
              //       "12.5. a statement by you that you have a good faith belief that the disputed use is not authorized by the copyright owner, its agent, or the law;"
              //       "12.6. a statement by you, made under penalty of perjury, that the above information in your notice is accurate and that you are the copyright owner or authorized to act on the copyright owner’s behalf."
              //       "You can contact our Copyright Agent via email at support@funky.global."
              //       "Error Reporting and Feedback"
              //       "You may provide us either directly at www.funky.global. or via third party sites and tools with information and feedback concerning errors, suggestions for improvements, ideas, problems, complaints, and other matters related to our Service (“Feedback”). You acknowledge and agree that: (i) you shall not retain, acquire or assert any intellectual property right or other right, title or interest in or to the Feedback; (ii) Company may have development ideas similar to the Feedback; (iii) Feedback does not contain confidential information or proprietary information from you or any third party; and (iv) Company is not under any obligation of confidentiality with respect to the Feedback. In the event the transfer of the ownership to the Feedback is not possible due to applicable mandatory laws, you grant Company and its affiliates an exclusive, transferable, irrevocable, free-of-charge, sub-licensable, unlimited and perpetual right to use (including copy, modify, create derivative works, publish, distribute and commercialize) Feedback in any manner and for any purpose."
              //       "Links To Other Web Sites"
              //       "Our Service may contain links to third party web sites or services that are not owned or controlled by Funky Pte. Ltd."
              //       "Funky Pte. Ltd. has no control over, and assumes no responsibility for the content, privacy policies, or practices of any third party web sites or services. We do not warrant the offerings of any of these entities/individuals or their websites."
              //       "You acknowledge and agree that Funky shall not be responsible or liable, directly or inndirectly, for any damage or loss caused or alleged to be caused by or in connection with use of or reliance on any such content, goods or services available on or through any such third party websites or services."
              //       "We strongly advise you to read the terms od service and provacy policies of any thrid party web sites or services that you visit."
              //       "Disclaimer Of Warranty"
              //       "These services are provided by company on an “as is” and “as” available” basis. Funky makes no representations or warranties of any kind, express or implied, as to the operation of their services, or the insormation, content or materials included therein, You expressly agree that your use of these services, their content, and any services or items obtained from us is at your sole risk."
              //       "Neither company nor any person associated with company makes any warranty or representation with respect to the completeness, security, reliability, quality, accuracy or availability of the services, wothout limiting the foregoing, neither company not anyone associated with Funky represents or warrants that the services, their content, or any services or items obtanied through the services will be accurate, reliable. Error-free, or uninterupted, that defects will be corrected, that the services or the server that makes it available are free of virues or other harmful conponents or that the services or any services or items obtained through the services will otherwise meet your needs or expectations."
              //       "Funky hereby disclaims all warranties of any kind, whether express or implied, statutory, or otherwise. Including but not limited to any warranties or merchantability, non-infringement, and fitness for particular purpose."
              //       "The foregoing does not affect any warranties which cannot be excluded or mited under applicable law."
              //       "Limitation Of Liability"
              //       "Except as prohibited by law, you will hold us and our officers, directors, employees, and agents harmless for any indirect, punitive special, incidental, or consequential damage, however it arieses (including attorneys’ fees and all related costs and expenses of litigation and arbitrationis instituted). Whether in an action of contract, negligence, or other tortious action or arising out of in connection with this agreement, including without limititation any claim for personal injury or property damage, arising from this agreement and any violation by you of any federal, state or local laws, statutes, rules or regulations, even if company has been previously advised of the possibility of such damage except as prohibited by law, if there is liability found on the part of company. It will be limited to the amount paid for the products and/or services, and under no corcumstances, will there be consequential or punitive damages, some states do not allow the exclusion or limitation of punitive, incidental or consequential damages so the prior limitation or exclusin may not apply to you."
              //       "Termination"
              //       "We may terminate or suspend your account and bar access to Service immediately, without prior notice or liability, under our sole discretion, for any reason whatsoever and without limitation, including but not limited to a breach of Terms."
              //       "If you wish to terminate your account, you may simply discontinue using Service."
              //       "All provisions of Terms which by their nature should survive termination shall survive termination, including, without limitation, ownership provisions, warranty disclaimers, indemnity and limitations of liability."
              //       "Governing Law"
              //       "These Terms shall be governed and construed in accordance with the laws of Singapore, which governing law applies to agreement without regard to its conflict of law provisions.Other countries such as California, Brazil, Indonesia, Turkey, United Arab Emirates, Mexico, Residents of the EEA and Switzerland, If you are not in the US, EEA, the United Kingdom, Switzerland or India, Residents of the United Kingdom, If you are a user having your usual residence in India, If you are a user having your usual residence in the US. the governing law follows your countries international law and community guidelines provided it doesn’t conflict with the Law of Singapore as the main law used. Your country’s international law is solely used to cover the loopholes of the main law."
              //       "Our failure to enforce any right or provision of these Terms will not be considered a waiver of those rights. If any provision of these Terms is held to be invalid or unenforceable by a court, the remaining provisions of these Terms will remain in effect. These Terms constitute the entire agreement between us regarding our Service and supersede and replace any prior agreements we might have had between us regarding Service."
              //       "Entire Agreement.These Terms (including the Supplemental Terms below) constitute the whole legal agreement between you and Funky and replace any prior applicable Terms and Conditions that governed the service prior to the Last Updated date specified above."
              //       "Changes To Service"
              //       "We reserve the right to withdraw or amend our Service, and any service or material we provide via Service, in our sole discretion without notice. We will not be liable if for any reason all or any part of Service is unavailable at any time or for any period. From time to time, we may restrict access to some parts of Service, or the entire Service, to users, including registered users."
              //       "Amendments To Terms"
              //       "We may amend Terms at any time by posting the amended terms on this site. It is your responsibility to review these Terms periodically."
              //       "Your continued use of the Platform following the posting of revised Terms means that you accept and agree to the changes. You are expected to check this page frequently so you are aware of any changes, as they are binding on you."
              //       "By continuing to access or use our Service after any revisions become effective, you agree to be bound by the revised terms. If you do not agree to the new terms, you are no longer authorized to use Service."
              //       "No Waiver"
              //       "Our failure to insist upon or enforce any provision of these Terms (or to exercise any other right or remedy under these Terms) shall not be construed as a waiver of any provision or right under these Terms nor shall it prevent or restrict the further exercise of that or any other right or remedy."
              //       "Severability"
              //       "If any court of law, having jurisdiction to decide on this matter, rules that any provision of these Terms is invalid, illegal or unenforceable then that provision shall be removed from the Terms without affecting the rest of the Terms, and the remaining provisions of the Terms will continue to be valid and enforceable."
              //       "Acknowledgement"
              //       "By using service or other services provided by us, you acknowledge that you have read these terms of service and agree to be bound by them."
              //       "Indemnify"
              //       "You agree to defend, indemnify, and hold harmless Funky, its parents, subsidiaries, and affiliates, and each of their respective officers, directors, employees, agents and advisors from any and all claims, liabilities, costs, damages, losses and expenses (including, but not limited to, attorneys’ fees and expenses) arising out of or in connection with any breach by you (or any user of your account for any of the services) of these terms, including but not limited to a breach of your obligations, representation and warranties."
              //       "Other terms"
              //       "To the extent permitted by applicable law, the following supplemental terms shall apply when accessing the Platform through specific devices: App Stores, Google Play, Amazon AppStore, windows Phone store. By downloading the Platform from a device made by aboved named devices and stores or any other relevant sources, you specifically acknowledge and agree that these terms between Funky and you and aboved named devices and stores or any other relevant sources,  is not a party to these Terms."
              //       "The license granted to you hereunder is limited to a personal, limited, non-exclusive, non-transferable right to install the Platform on the device or devices , hereinafter device, authorised by device or app store companies that you own or control for personal, non-commercial use, subject to the usage rules set forth in device or appstore terms of services."
              //       "The device or app store companies is not responsible for the Platform or the content thereof and has no obligation whatsoever to furnish any maintenance or support services with respect to the Platform."
              //       "In the event of any failure of the Platform to conform to any applicable warranty, you may notify device or app store companies, and device or app store companies will refund the purchase price for the Platform, if any, to you. To the maximum extent permitted by applicable law, device or app store companies will have no other warranty obligation whatsoever with respect to the Platform."
              //       "The device or app store companies is not responsible for addressing any claims by you or a third party relating to the Platform or your possession or use of the Platform, including without limitation (a) product liability claims; (b) any claim that the Platform fails to conform to any applicable legal or regulatory requirement; and (c) claims arising under consumer protection or similar legislation."
              //       "In the event of any third party claim that the Platform or your possession and use of the Platform infringes such third party’s intellectual property rights,the device or app store companies is not responsible for the investigation, defence, settlement or discharge of such intellectual property infringement claim."
              //       "You represent and warrant that (a) you are not located in a country that is subject to a U.S. Government embargo, or that has been designated by the U.S. Government as a “terrorist supporting” country; and (b) you are not listed on any U.S. Government list of prohibited or restricted parties."
              //       "The device or app store companies and its subsidiaries are third party beneficiaries of these Terms and upon your acceptance of the terms and conditions of these terms, the device or app store companies will have the right (and will be deemed to have accepted the right) to enforce these Terms against you as a third party beneficiary hereof."
              //       "Funky expressly authorises use of the platform by multiple users through the family sharing or any similar functionality provided by the device or app store companies."
              //       "Supplemental Terms – App Stores"
              //       "To the extent permitted by applicable law, the following supplemental terms shall apply in respect of the Funky (the App):"
              //       "Apple App Store. By accessing the App through a device made by Apple, Inc. (“Apple”), you specifically acknowledge and agree that:"
              //       "These Terms are between the Company and you; Apple is not a party to these Terms."
              //       "The license granted to you hereunder is limited to a personal, limited, non-exclusive, non-transferable right to install the App on the Apple device(s) authorized by Apple that you own or control for personal, non-commercial use, subject to the Usage Rules set forth in Apple’s App Store Terms and Conditions."
              //       "Apple is not responsible for the App or the content thereof and has no obligation whatsoever to furnish any maintenance or support services with respect to the App."
              //       "In the event of any failure of the App to conform to any applicable warranty, you may notify Apple, and Apple will refund the purchase price for the App, if any, to you. To the maximum extent permitted by applicable law, Apple will have no other warranty obligation whatsoever with respect to the App."
              //       "Apple is not responsible for addressing any claims by you or a third party relating to the App or your possession or use of the App, including without limitation (a) product liability claims; (b) any claim that the App fails to conform to any applicable legal or regulatory requirement; and (c) claims arising under consumer protection or similar legislation."
              //       "In the event of any third-party claim that the App or your possession and use of the App infringes such third party’s intellectual property rights, Apple is not responsible for the investigation, defence, settlement or discharge of such intellectual property infringement claim."
              //       "You represent and warrant that (a) you are not located in a country that is subject to a U.S. Government embargo, or that has been designated by the U.S. Government as a “terrorist supporting” country; and (b) you are not listed on any U.S. Government list of prohibited or restricted parties."
              //       "Apple and its subsidiaries are third party beneficiaries of these Terms and upon your acceptance of the terms and conditions of these Terms, Apple will have the right (and will be deemed to have accepted the right) to enforce these Terms against you as a third-party beneficiary hereof."
              //       "Funky expressly authorizes use of the App by multiple users through the Family Sharing or any similar functionality provided by Apple."
              //       "Google Play. By downloading the App from Google Play (or its successors) operated by Google, Inc. or one of its affiliates (“Google”), you specifically acknowledge and agree that:"
              //       "to the extent of any conflict between (a) the Google Play Terms of Service and the Google Play Business and Program Policies or such other terms which Google designates as default end user license terms for Google Play (all of which together are referred to as the “Google Play Terms”), and (b) the other terms and conditions in these Terms, the Google Play Terms shall apply with respect to your use of the App that you download from Google Play, and"
              //       "you hereby acknowledge that Google does not have any responsibility or liability related to compliance or non-compliance by the Company or you (or any other user) under these Terms or the Google Play Terms."
              //       "Supplemental Terms – Jurisdiction Specific"
              //       "THE UNITED STATES"
              //       "If you are using the Platform in the United States, the following additional terms apply:"
              //       "Governing Law. These Terms, their subject matter and their formation, are governed by the laws of the State of California."
              //       "Arbitration and Class Action Waiver"
              //       "This Section includes an arbitration agreement and an agreement that all claims will be brought only in an individual capacity (and not as a class action or other representative proceeding). Please read it carefully. YOU MAY OPT OUT OF THE ARBITRATION AGREEMENT BY FOLLOWING THE OPT OUT PROCEDURE DESCRIBED BELOW."
              //       "Informal Process First. You agree that in the event of any dispute between you and the Company, you will first contact the Company and make a good faith sustained effort to resolve the dispute before resorting to more formal means of resolution, including without limitation any court action."
              //       "Arbitration Agreement. After the informal dispute resolution process any remaining dispute, controversy, or claim (collectively, “Claim”) relating in any way to your use of the Company’s services and/or products, including the Services, will be finally resolved by binding arbitration. This mandatory arbitration agreement applies equally to you and the Company. However, this arbitration agreement does not (a) govern any Claim by the Company for infringement of its intellectual property or access to the Services that is unauthorized or exceeds authorization granted in these Terms or (b) bar you from making use of applicable small claims court procedures in appropriate cases."
              //       "You agree that the U.S. Federal Arbitration Act governs the interpretation and enforcement of this provision, and that you and the Company are each waiving the right to a trial by jury or to participate in a class action. This arbitration provision will survive any termination of these Terms."
              //       "If you wish to begin an arbitration proceeding, after following the informal dispute resolution procedure, you must send a letter requesting arbitration and describing your claim to the Company via email at support@funky.global"
              //       "The arbitration will be administered by the American Arbitration Association (AAA) under its rules including, if you are an individual, the AAA’s Supplementary Procedures for Consumer-Related Disputes. If you are not an individual or have used the Services on behalf of an entity, the AAA’s Supplementary Procedures for Consumer-Related Disputes will not be used. The AAA’s rules are available at www.adr.org or by calling 1-800-778-7879."
              //       "The arbitration proceeding will be conducted in Los Angeles, California in the English language."
              //       "Payment of all filing, administration and arbitrator fees will be governed by the AAA’s rules. If you are an individual and have not accessed or used the Services on behalf of an entity, we will reimburse those fees for claims where the amount in dispute is less than \$10,000, unless the arbitrator determines the claims are frivolous, and we will not seek attorneys’ fees and costs in arbitration unless the arbitrator determines the claims are frivolous."
              //       "The arbitrator, and not any federal, state, or local court, will have exclusive authority to resolve any dispute relating to the interpretation, applicability, unconscionability, arbitrability, enforceability, or formation of this arbitration agreement, including any claim that all or any part of this arbitration agreement is void or voidable. However, the preceding sentence will not apply to the “Class Action Waiver” section below."
              //       "If you do not want to arbitrate disputes with the Company and you are an individual, you may opt out of this arbitration agreement by sending a notice via email: support@funky.global within thirty (30) days of the first of the date you access or use the Services."
              //       "CLASS ACTION WAIVER. ANY CLAIM MUST BE BROUGHT IN THE RESPECTIVE PARTY’S INDIVIDUAL CAPACITY, AND NOT AS A PLAINTIFF OR CLASS MEMBER IN ANY PURPORTED CLASS, COLLECTIVE, REPRESENTATIVE, MULTIPLE PLAINTIFF, OR SIMILAR PROCEEDING (“CLASS ACTION”). THE PARTIES EXPRESSLY WAIVE ANY ABILITY TO MAINTAIN ANY CLASS ACTION IN ANY FORUM. IF THE CLAIM IS SUBJECT TO ARBITRATION, THE ARBITRATOR WILL NOT HAVE AUTHORITY TO COMBINE OR AGGREGATE SIMILAR CLAIMS OR CONDUCT ANY CLASS ACTION NOR MAKE AN AWARD TO ANY PERSON OR ENTITY NOT A PARTY TO THE ARBITRATION. ANY CLAIM THAT ALL OR PART OF THIS CLASS ACTION WAIVER IS UNENFORCEABLE, UNCONSCIONABLE, VOID, OR VOIDABLE MAY BE DETERMINED ONLY BY A COURT OF COMPETENT JURISDICTION AND NOT BY AN ARBITRATOR."
              //       "If this class action waiver is found to be invalid or unenforceable, then the entirety of the Arbitration Agreement, if otherwise effective, will be null and void. If any other provision of the Arbitration Agreement is held to be invalid or unenforceable, such provision shall be struck and the remaining provisions shall be enforced to the fullest extent under the law."
              //       "If for any reason a claim proceeds in court rather than in arbitration, you and the Company each waive any right to a jury trial."
              //       "California Resident. If you are a California resident, in accordance with Cal. Civ. Code § 1789.3, you may report complaints to the Complaint Assistance Unit of the Division of Consumer Services of the California Department of Consumer Affairs by contacting them in writing at 1625 North Market Blvd., Suite N 112 Sacramento, CA 95834, or by telephone at (800) 952-5210."
              //       "Exports. You agree that you will not export or re-export, directly or indirectly the Services and/or other information or materials provided by the Company hereunder, to any country for which the United States or any other relevant jurisdiction requires any export license or other governmental approval at the time of export without first obtaining such license or approval. In particular, but without limitation, the Services may not be exported or re-exported (a) into any U.S. embargoed countries or any country that has been designated by the U.S. Government as a “terrorist supporting” country, or (b) to anyone listed on any U.S. Government list of prohibited or restricted parties, including the U.S. Treasury Department's list of Specially Designated Nationals or the U.S. Department of Commerce Denied Person’s List or Entity List."
              //       "U.S. Government Restricted Rights. The Services and related documentation are 'Commercial Items', as that term is defined at 48 C.F.R. §2.101, consisting of 'Commercial Computer Software' and 'Commercial Computer Software Documentation', as such terms are used in 48 C.F.R. §12.212 or 48 C.F.R. §227.7202, as applicable. Consistent with 48 C.F.R. §12.212 or 48 C.F.R. §227.7202-1 through 227.7202-4, as applicable, the Commercial Computer Software and Commercial Computer Software Documentation are being licensed to U.S. Government end users (a) only as Commercial Items and (b) with only those rights as are granted to all other end users pursuant to the terms and conditions herein."
              //       "Your Content. In connection with your use of the Services, you may be able to upload or submit content to be made available through the Services (“Your Content”). As a condition of your use of the Services, you grant us a nonexclusive, perpetual, irrevocable, royalty-free, worldwide, transferable, sublicensable license to access, use, host, cache, reproduce, transmit, and display Your Content in connection with your use of the Services. By submitting Your Content through the Services, you represent and warrant that you have, or have obtained, all rights, licenses, consents, permissions, power and/or authority necessary to grant the rights granted herein for Your Content. You agree that Your Content will not contain material subject to copyright or other proprietary rights, unless you have the necessary permission or are otherwise legally entitled to upload the material and to grant us the license described above. Notwithstanding anything to the contrary, we do not, nor have any obligation to maintain Your Content. Your Content will not be available once you delete the Platform."
              //       "Use of the Platform. You are responsible for providing the mobile device, wireless service plan, software, Internet connections and/or other equipment or services that you need to download, install and use the Platform. We do not guarantee that the Platform can be accessed and used on any particular device or with any particular service plan. We do not guarantee that the Platform or will be available in any particular geographic location. As part of the Services, you may receive push notifications or other types of messages directly sent to you in connection with the Platform (“Push Messages”). You acknowledge that, when you use the Platform, your wireless service provider may charge you fees for data, text messaging and/or other wireless access, including in connection with Push Messages. You have control over the Push Messages settings, and can opt in or out of these Push Messages through the Services or through your mobile device’s operating system (with the possible exception of infrequent, important service announcements and administrative messages). Please check with your wireless service provider to determine what fees apply to your access to and use of the Platform, including your receipt of Push Messages. You are solely responsible for any fee, cost or expense that you incur to download, install and/or use the Platform on your mobile device, including for your receipt of Push Messages."
              //       "BRAZIL"
              //       "If you are using the Platform in Brazil, the following additional terms apply:"
              //       "Accepting the Terms. To use or access the Platform, you must agree with the Terms. Be aware that the provisions herein will govern the relationship between you and the Platform. If you do not agree with all terms below, you will not be allowed to use or access the Platform. Your access to and use of our Services is also subject to our Privacy Policy, which you also have to agree with, and the terms of which can be found directly on the Platform, or where the Platform is made available for download, on your mobile device’s applicable app store, and is incorporated herein by reference."
              //       "Parental and Guardian Consent. If you are 16 years of age or above but under the age of 18, you declare that you had the assistance of your parent or legal guardian to use the Services and to agree to the Terms. If you are under the age of 16, your parent or legal guardian must agree to the Terms on your behalf, otherwise you cannot use the Services. If you are the parent or legal guardian responsible for the minor, this Terms are applicable to you, and you hereby agree with them."
              //       "Changes to the Terms. In the case of relevant changes that require the user´s consent, we will present the new Terms to obtain your consent in relation to the new Terms."
              //       "Applicable Law and Jurisdiction. These Terms, their subject matter and their formation, are governed by Brazilian law. You and we both agree that the courts of Brazil will have exclusive jurisdiction."
              //       "Your Content. In connection with your use of the Services, you may be able to upload or submit content to be made available through the Services (“Your Content”). As a condition of your use of the Services, you grant us a nonexclusive, perpetual, irrevocable, royalty-free, worldwide, transferable, sublicensable license to access, use, host, cache, reproduce, transmit, and display Your Content in connection with your use of the Services. By submitting Your Content through the Services, you represent and warrant that you have, or have obtained, all rights, licenses, consents, permissions, power and/or authority necessary to grant the rights granted herein for Your Content. You agree that Your Content will not contain material subject to copyright or other proprietary rights, unless you have the necessary permission or are otherwise legally entitled to upload the material and to grant us the license described above. Notwithstanding anything to the contrary, we do not, nor have any obligation to maintain Your Content. Your Content will not be available once you delete the Platform."
              //       "Use of the Platform. You are responsible for providing the mobile device, wireless service plan, software, Internet connections and/or other equipment or services that you need to download, install and use the Platform. We do not guarantee that the Platform can be accessed and used on any particular device or with any particular service plan. We do not guarantee that the Platform or will be available in any particular geographic location. As part of the Services, you may receive push notifications or other types of messages directly sent to you in connection with the Platform (“Push Messages”). You acknowledge that, when you use the Platform, your wireless service provider may charge you fees for data, text messaging and/or other wireless access, including in connection with Push Messages. You have control over the Push Messages settings, and can opt in or out of these Push Messages through the Services or through your mobile device’s operating system (with the possible exception of infrequent, important service announcements and administrative messages). Please check with your wireless service provider to determine what fees apply to your access to and use of the Platform, including your receipt of Push Messages. You are solely responsible for any fee, cost or expense that you incur to download, install and/or use the Platform on your mobile device, including for your receipt of Push Messages."
              //       "Termination. We reserve the right, in our sole discretion, to deny access to the app by any User, or to modify, suspend or terminate any User's access to or use of the app at any time, for any reason or for no reason, without notice. We may also, in our sole discretion and at any time, discontinue providing the app, or any part thereof, with or without notice. We may notify the User about the termination or suspension of the account or discontinuance of the app within 15-day prior notice given by communication via e-mail, message, app or other alternative means of communication only if User has not given cause for such termination, suspension or discontinuance, otherwise we are not obliged to prior communicate the User."
              //       "JAPAN"
              //       "If you are using the Platform in Japan, the following additional terms apply:"
              //       "Age of Majority. If you are under 20 years old, you confirm that your parent or legal guardian consents to your access or use of the Service. Please be sure your parent or legal guardian has reviewed and discussed these Terms with you. If you have accessed or used the Service after you become 20 years old, you are deemed to have been consented to use the Service during the period while you were under 20 years old."
              //       "    SOUTH KOREA"
              //       "    If you are using the Platform in South Korea, the following additional terms apply:"
              //       "    Applicable Law and Jurisdiction. These Terms, their subject matter and their formation, are governed by Korean law. You and we both agree that courts of Korea will have exclusive jurisdiction."
              //       "   Limitation of Liabilities. No limitation of liabilities set out above shall be applicable to the extent any loss or damage is incurred by you as a result of our wilful misconduct or negligence."
              //       " Parental and Guardian Consent. The Services are only available for individuals 14 years old and over. If you are over the age of 14 but under the age of 19, you declare that you have the consent of your parent or legal guardian to receive the Services or to register an account for the Services."
              //       " Change to the terms. The following terms shall apply with priority over Section 20 above."
              //       " We amend these Terms from time to time to the extent that is permitted by the applicable laws."
              //       " In the event we amend these Terms, we will notify you of the effective date of the changes and the reasons for applying the amendments through a notice to be posted on the landing page of our website or the splash screen of our mobile app, starting at least 7 days before the effective date of the new Terms until the day before the effective date; provided, however, in the event of any amendments that are material or will be disadvantageous to you, we will make reasonable efforts to provide prior notice to you, and the new Terms shall take effect at least 30 days after the first date of notice. However, any changes related to the new functions of the service that benefit users or for legal reasons may be effective immediately."
              //       " If you fail to explicitly express your objection to the amended Terms even though we notified you that your failure to do so within the above advance notification period will be considered as an acceptance of the changes, you will be considered to have agreed to the new Terms."
              //       " Content. The following terms shall apply with priority over the second paragraph of Section 5 above."
              //       " Subject to the terms and conditions of the Terms, you are hereby granted a non-exclusive, limited, non-transferable, non-sublicensable, revocable license to access and use the Services, including the downloading of the Platform on a permitted device, and to access the Company’s Content solely for your personal, non-commercial use through your use of the Services and solely in compliance with these Terms. The Company reserves all rights not expressly granted herein in the Services and the Company’s Content. You acknowledge and agree that the Company may terminate this license at any time for any reason or no reason, if deemed necessary at our reasonable discretion."
              //       " We will not disclose your identity to any third party unless permitted by the applicable law or with your consent."
              //       " Prior Notification of Service Restrictions, etc. In the event we implement changes that are unfavourable to you (including our suspension or restriction of the availability of our Services), we will notify you in individually of the reason for the action without delay. However, in the event that individual notice is prohibited for legal reasons or is reasonably deemed to cause harm to Users, third parties, Funky and our affiliates (e.g., if the notification violates the laws and regulations or the order of the regulatory authorities, if it interferes with any investigations, if it damages the security of our Services, etc.), the notification may not be issued."
              //       " Consent to the Terms. The following terms shall apply with priority over the first paragraph of Section 1 above. These Terms are effectuated when you consent to these Terms, submit a request to use the relevant service and we accept such request. Your access to and use of our Services are also subject to our Privacy Policy , the terms of which can be found directly on the Platform, or where the Platform is made available for download, on your mobile device’s applicable app store, and is incorporated herein by reference. Notwithstanding Section 2 above, by consenting to these Terms, you are not consenting to our Privacy Policy. You must consent to the Privacy Policy separately from these Terms."
              //       " THAILAND"
              //       " If you are using the Platform in Thailand, the following additional terms apply:"
              //       " Parental and Guardian Consent. If you are under the age of 20, or if you are a quasi-incompetent person, or an incompetent person, you declare that your parent or legal guardian has acknowledged to these Terms and you had the consent of your parent or legal guardian to use the Services."
              //       "EUROPEAN UNION"
              //       "The following terms apply if you reside in the European Union:"
              //       "Nothing in these Terms affects your right to rely on any applicable mandatory local law or choice of jurisdiction provision that cannot be varied by contract. The European Commission provides for an online dispute resolution platform, which you can access at https://ec.europa.eu/consumers/odr/."
              //       "Without prejudice to your statutory rights, we may, without notice, temporarily or permanently suspend or cancel your account or impose limits on or restrict your access to parts or all of your account or the Services:"
              //       "if you violate, or we believe you are about to violate, the Terms, including any incorporated agreements, policies or guidelines;"
              //       "in response to requests by law enforcement or other government agencies under valid legal process;"
              //       "due to unexpected technical or security issues or problems; or"
              //       "if your account shows extended periods of inactivity in accordance with our account deletion policy."
              //       "If we permanently suspend or terminate your account, we will notify you in advance and allow you reasonable time to access and save information, files, and content associated with your account unless we have reason to believe that continued access to your account will violate applicable legal provisions, requests by law enforcement or other government agencies, or cause damage to us or to third parties."
              //       "Nothing in the Terms affects any legal rights that you are entitled to as a consumer under European Union member state laws which cannot be contractually altered or waived. Accordingly, some of the exclusions and limitations in Sections 9 and 10 of the Terms will not apply to you if you are a consumer living in a European Union country."
              //       "If you reside in Germany Sections 15 and 16 of the terms are replaced by the following:"
              //       "For damages with respect to injury to health, body or life caused by us, our representatives or our agents in the performance of the contractual obligations, we are fully liable. We are fully liable for damages caused wilfully or by gross negligence by us, our representatives or our agents in the performance of the contractual obligations. The same applies to damages which result from the absence of a quality which was guaranteed by us or to damages which result from malicious action. If damages with respect to a breach of a contractual core duty are caused by slight negligence, we are liable only for the amount of the damage which was typically foreseeable. Contractual core duties, abstractly, are such duties whose accomplishment enables proper performance of an agreement in the first place and whose performance a contractual party regularly may rely on. Our liability based on the German Product Liability Act remains unaffected. Any further liability is excluded. The limitation period for claims for damages against us expires after one (1) year."
              //       "These Terms, their subject matter and their formation, are governed by the laws of Singapore subject only to any mandatory provisions of consumer law in the European Union country in which you reside. The United Nations Convention on Contracts for the International Sale of Goods as well as any other similar law, regulation or statute in effect in any other jurisdiction shall not apply. You and Funky irrevocably agree that the courts of the country in which you reside shall have non-exclusive jurisdiction to settle any dispute or claim (including non-contractual disputes or claims) arising out of or in connection with this Agreement or its subject matter or formation."
              //       "INDIA"
              //       "If you are using the Platform in India, the following additional terms shall apply:"
              //       "By using the Services you confirm you are at least 18 years old or are at least 18 years old and supervising the usage of this Platform by your minor dependent."
              //       "Complaints or other issue faced by you in your use of the Platform may be submitted through email at the address: support@funky.global."
              //       "Contact Us"
              //       "Please send your feedback, comments, requests for technical support by email: support@funky.global",
              //       style: TextStyle(
              //           fontSize: 16,
              //           color: Colors.white,
              //           fontFamily: 'PR',
              //           height: 1.5),
              //       textAlign: TextAlign.justify,
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
