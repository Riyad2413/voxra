import 'package:flutter/material.dart';
void main()=>runApp(const VoxraApp());
const purple=Color(0xFF8064FF), bg=Color(0xFF090B12), panel=Color(0xFF151925);
class VoxraApp extends StatelessWidget {
 const VoxraApp({super.key});
 @override Widget build(BuildContext context)=>MaterialApp(title:'Voxra',debugShowCheckedModeBanner:false,
 theme:ThemeData(brightness:Brightness.dark,scaffoldBackgroundColor:bg,colorScheme:ColorScheme.fromSeed(seedColor:purple,brightness:Brightness.dark),useMaterial3:true,inputDecorationTheme:InputDecorationTheme(filled:true,fillColor:panel,border:OutlineInputBorder(borderRadius:BorderRadius.circular(16),borderSide:BorderSide.none))),
 home:const LoginScreen());
}
class LoginScreen extends StatefulWidget {const LoginScreen({super.key}); @override State<LoginScreen> createState()=>_LoginScreenState();}
class _LoginScreenState extends State<LoginScreen>{
 final user=TextEditingController(), pass=TextEditingController(); bool hide=true;
 @override void dispose(){user.dispose();pass.dispose();super.dispose();}
 void enter(){if(user.text.trim().isEmpty){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Enter a username or Voxra ID')));return;} Navigator.pushReplacement(context,MaterialPageRoute(builder:(_)=>HomeScreen(username:user.text.trim())));}
 @override Widget build(BuildContext context)=>Scaffold(body:SafeArea(child:Center(child:SingleChildScrollView(padding:const EdgeInsets.all(26),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[
 const SizedBox(height:24),Container(width:88,height:88,decoration:BoxDecoration(borderRadius:BorderRadius.circular(28),gradient:const LinearGradient(colors:[purple,Color(0xFF428BFF)])),child:const Icon(Icons.graphic_eq_rounded,size:48)),
 const SizedBox(height:20),const Text('VOXRA',style:TextStyle(fontSize:34,fontWeight:FontWeight.w900,letterSpacing:6)),const SizedBox(height:7),const Text('Your voice. Your privacy.',style:TextStyle(color:Colors.white60)),const SizedBox(height:42),
 TextField(controller:user,textInputAction:TextInputAction.next,decoration:const InputDecoration(prefixIcon:Icon(Icons.person_outline),hintText:'Username / Voxra ID')),const SizedBox(height:14),
 TextField(controller:pass,obscureText:hide,decoration:InputDecoration(prefixIcon:const Icon(Icons.lock_outline),hintText:'Password (demo only)',suffixIcon:IconButton(onPressed:()=>setState(()=>hide=!hide),icon:Icon(hide?Icons.visibility_off:Icons.visibility)))),
 const SizedBox(height:22),SizedBox(width:double.infinity,height:54,child:FilledButton(style:FilledButton.styleFrom(backgroundColor:purple,shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(16))),onPressed:enter,child:const Text('CONTINUE',style:TextStyle(fontWeight:FontWeight.bold,letterSpacing:1)))),
 const SizedBox(height:12),const Text('V1 preview • no phone number required',style:TextStyle(color:Colors.white38,fontSize:12))
 ])))));
}
class Friend {final String name,id; final bool online; const Friend(this.name,this.id,this.online);}
class HomeScreen extends StatefulWidget {final String username;const HomeScreen({super.key,required this.username});@override State<HomeScreen> createState()=>_HomeScreenState();}
class _HomeScreenState extends State<HomeScreen>{
 final search=TextEditingController();int tab=0;
 final people=const [Friend('NightWolf','NW-4821',true),Friend('ShadowX','SX-1058',true),Friend('SilentFox','SF-7730',false),Friend('DarkEcho','DE-2904',false)];
 @override void dispose(){search.dispose();super.dispose();}
 @override Widget build(BuildContext context){final filtered=people.where((p)=>p.name.toLowerCase().contains(search.text.toLowerCase())||p.id.toLowerCase().contains(search.text.toLowerCase())).toList();
 return Scaffold(appBar:AppBar(title:const Text('VOXRA',style:TextStyle(fontWeight:FontWeight.w900,letterSpacing:3)),actions:[IconButton(onPressed:()=>showAboutDialog(context:context,applicationName:'Voxra V1',children:const [Text('UI prototype. Real calling and voice effects are not connected yet.')]),icon:const Icon(Icons.info_outline))]),
 body:tab==0?Padding(padding:const EdgeInsets.fromLTRB(18,8,18,12),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
 Container(padding:const EdgeInsets.all(18),decoration:BoxDecoration(borderRadius:BorderRadius.circular(22),gradient:const LinearGradient(colors:[Color(0xFF211A40),Color(0xFF131927)])),child:Row(children:[const CircleAvatar(radius:28,backgroundColor:purple,child:Icon(Icons.person,size:30)),const SizedBox(width:14),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(widget.username,style:const TextStyle(fontSize:18,fontWeight:FontWeight.bold)),const SizedBox(height:5),const Text('Private ID • VX-7K29',style:TextStyle(color:Colors.white60,fontSize:12))])),const Icon(Icons.verified_user_outlined,color:Colors.white54)])),
 const SizedBox(height:18),TextField(controller:search,onChanged:(_)=>setState(()=>{}),decoration:const InputDecoration(prefixIcon:Icon(Icons.search),hintText:'Search by username or ID')),const SizedBox(height:22),const Text('People',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),const SizedBox(height:10),
 Expanded(child:ListView(children:filtered.map((p)=>Container(margin:const EdgeInsets.only(bottom:10),decoration:BoxDecoration(color:panel,borderRadius:BorderRadius.circular(18)),child:ListTile(leading:CircleAvatar(radius:24,backgroundColor:const Color(0xFF292D3D),child:Text(p.name.substring(0,1),style:const TextStyle(fontWeight:FontWeight.bold))),title:Text(p.name,style:const TextStyle(fontWeight:FontWeight.bold)),subtitle:Text('${p.online?"Online":"Offline"} • ${p.id}',style:const TextStyle(color:Colors.white54,fontSize:12)),trailing:IconButton(icon:const Icon(Icons.call_rounded,color:purple),onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>CallScreen(friend:p)))))).toList()))
 ])):Center(child:Column(mainAxisSize:MainAxisSize.min,children:[Icon(tab==1?Icons.call_made_rounded:Icons.person_outline,size:52,color:purple),const SizedBox(height:12),Text(tab==1?'No recent calls':widget.username,style:const TextStyle(fontSize:20,fontWeight:FontWeight.bold)),const SizedBox(height:6),const Text('Voxra V1 preview',style:TextStyle(color:Colors.white54))])),
 bottomNavigationBar:NavigationBar(backgroundColor:const Color(0xFF10131C),selectedIndex:tab,onDestinationSelected:(i)=>setState(()=>tab=i),destinations:const [NavigationDestination(icon:Icon(Icons.home_outlined),selectedIcon:Icon(Icons.home),label:'Home'),NavigationDestination(icon:Icon(Icons.call_outlined),selectedIcon:Icon(Icons.call),label:'Calls'),NavigationDestination(icon:Icon(Icons.person_outline),selectedIcon:Icon(Icons.person),label:'Profile')]));
 }
}
class CallScreen extends StatefulWidget {final Friend friend;const CallScreen({super.key,required this.friend});@override State<CallScreen> createState()=>_CallScreenState();}
class _CallScreenState extends State<CallScreen>{
 bool muted=false,speaker=false;String effect='HEAVY';final effects=const ['NORMAL','DEEP','HEAVY','LOW'];
 @override Widget build(BuildContext context)=>Scaffold(body:SafeArea(child:Column(children:[
 Align(alignment:Alignment.centerLeft,child:IconButton(onPressed:()=>Navigator.pop(context),icon:const Icon(Icons.arrow_back))),const Spacer(),
 Container(width:112,height:112,decoration:const BoxDecoration(shape:BoxShape.circle,gradient:LinearGradient(colors:[purple,Color(0xFF428BFF)])),child:const Icon(Icons.person,size:62)),
 const SizedBox(height:22),Text(widget.friend.name,style:const TextStyle(fontSize:27,fontWeight:FontWeight.bold)),const SizedBox(height:8),Text('Ready to call (demo)',style:const TextStyle(color:Colors.greenAccent)),const SizedBox(height:34),
 Container(margin:const EdgeInsets.symmetric(horizontal:24),padding:const EdgeInsets.all(18),decoration:BoxDecoration(color:panel,borderRadius:BorderRadius.circular(22)),child:Column(children:[const Row(mainAxisAlignment:MainAxisAlignment.center,children:[Icon(Icons.graphic_eq,color:purple),SizedBox(width:8),Text('VOICE STYLE',style:TextStyle(fontWeight:FontWeight.bold,letterSpacing:1))]),const SizedBox(height:6),const Text('Visual preview only — no audio processing yet',textAlign:TextAlign.center,style:TextStyle(fontSize:12,color:Colors.white54)),const SizedBox(height:16),Wrap(spacing:8,runSpacing:8,alignment:WrapAlignment.center,children:effects.map((e)=>ChoiceChip(label:Text(e),selected:effect==e,onSelected:(_)=>setState(()=>effect=e)).toList())])),
 const Spacer(),Row(mainAxisAlignment:MainAxisAlignment.center,children:[control(muted?Icons.mic_off:Icons.mic,'Mute',muted,()=>setState(()=>muted=!muted)),const SizedBox(width:20),control(speaker?Icons.volume_up:Icons.volume_down,'Speaker',speaker,()=>setState(()=>speaker=!speaker)),const SizedBox(width:20),control(Icons.call_end,'End',false,()=>Navigator.pop(context),red:true)]),const SizedBox(height:36)
 ])));
 Widget control(IconData icon,String label,bool active,VoidCallback onTap,{bool red=false})=>Column(children:[InkWell(onTap:onTap,borderRadius:BorderRadius.circular(40),child:Container(width:62,height:62,decoration:BoxDecoration(shape:BoxShape.circle,color:red?Colors.redAccent:active?purple:const Color(0xFF202535)),child:Icon(icon,size:27))),const SizedBox(height:8),Text(label,style:const TextStyle(color:Colors.white60,fontSize:12))]);
}
