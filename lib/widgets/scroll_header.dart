import 'package:flutter/material.dart';

class ScrollHeader extends StatelessWidget{
  const ScrollHeader({super.key});

  @override
  Widget build(BuildContext context) {
   return SliverAppBar(
    automaticallyImplyLeading: false,
    pinned: false,
    floating: false,
    expandedHeight: 200,
    flexibleSpace: FlexibleSpaceBar(
      background: Container(
        color: Theme.of(context).colorScheme.inversePrimary,
        alignment: Alignment.center,
        child: Text(
          'Big Header Container',
          style: TextStyle(
            fontSize: 28,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

      ),
      
     
    ),
   );
   
  }


}