import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../model/post_model.dart';
import '../service/utils.dart';

class ShowModal{

 static void bottomSheeet({required BuildContext context,required List textModal,required double heightSize}) {
   showMaterialModalBottomSheet(
     shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
     context: context,
     builder: (context) => Container(
       padding: const EdgeInsets.only(left: 15,top: 10),
       height: MediaQuery.of(context).size.height*heightSize,
       child: Column(

         children: [
           Container(
             height: 5,
             width: 40,
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(10),
               color: Colors.grey,
             ),
             alignment: Alignment.center,
           ),

           Padding(
             padding: const EdgeInsets.only(top: 15,bottom: 10),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: [
                 Column(
                   children: [
                     Container(
                       child: IconButton(
                         padding: EdgeInsets.zero,
                         onPressed: (){},
                           icon: const Icon(FontAwesomeIcons.link,color: Colors.black,)),
                       height: 55,
                       width: 55,
                       decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(27),
                           color: Colors.white,
                           border: Border.all(color: Colors.grey.shade700)
                       ),
                     ),
                     const SizedBox(height: 10,),
                     const Text("Link",style: TextStyle(color: Colors.black),)
                   ],
                 ),
                 Column(
                   children: [
                     Container(
                       child: IconButton(
                         onPressed: (){

                         },
                           icon: const Icon(Icons.share,color: Colors.black,)),
                       height: 55,
                       width: 55,
                       decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(27),
                           color: Colors.white,
                           border: Border.all(color: Colors.grey.shade700)
                       ),
                     ),
                     const SizedBox(height: 10,),
                     const Text("Share",style: TextStyle(color: Colors.black),)
                   ],
                 ),
               ],
             ),
           ),

           const Divider(
             thickness: 1,
             endIndent: 0,
             indent: 0,
           ),

           ListView.builder(
             padding: EdgeInsets.zero,
             shrinkWrap: true,
             physics: const NeverScrollableScrollPhysics(),
             itemCount: textModal.length,
             itemBuilder: (context,index){
               return Container(
                 margin: const EdgeInsets.only(top: 25),
                 child: Row(
                   children: [
                     index != 2  ?
                     Text(textModal[index],style: TextStyle(fontSize: 16),) :
                     GestureDetector(
                         child: Text(textModal[index],style: TextStyle(fontSize: 16),),
                       onTap: (){
                           if(index == 2) {
                             //
                           }
                       },
                     )
                   ],
                 ),
               );
             },
           )
         ],
       ),
     ),
   );
 }

}