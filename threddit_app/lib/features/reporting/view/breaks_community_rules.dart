import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class BreakCommunityRules extends ConsumerStatefulWidget {
  const BreakCommunityRules(
      {super.key,required this.id,required this.type});
  final String id;
  final String type;
  @override
  _BreakCommunityRulesState createState() => _BreakCommunityRulesState();
}
class _BreakCommunityRulesState extends ConsumerState<BreakCommunityRules> {
  List<String> _communityRules=[];
  @override
  Widget build(BuildContext context) {
    if (widget.type =='post')
  {
    //fetch post 
    //fetch community if exists 
    //fetch community rules
  }
  if(widget.type=='comment')
  {
    //fetch comment
    //fetch post of the comment 
    //fetch community if exists 
    //fetch community rules
  }
  //return a list with the community rules to select from
    return Container();
  }
}