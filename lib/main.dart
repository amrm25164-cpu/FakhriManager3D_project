import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() => runApp(const FakhriManagerApp());

const bg = Color(0xFF071510);
const panel = Color(0xFF10271D);
const panel2 = Color(0xFF173729);
const lime = Color(0xFFB7F36B);
const muted = Color(0xFF9EB5A7);

class FakhriManagerApp extends StatelessWidget {
  const FakhriManagerApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Fakhri Manager',
    theme: ThemeData(useMaterial3: true, brightness: Brightness.dark, scaffoldBackgroundColor: bg,
      colorScheme: ColorScheme.fromSeed(seedColor: lime, brightness: Brightness.dark), fontFamily: 'Roboto'),
    home: const ManagerHome(),
  );
}

class Player {
  Player(this.name, this.position, this.rating, this.age, this.value, {this.morale = 78, this.fitness = 92, this.potential = 85});
  String name, position;
  int rating, age, value, morale, fitness, potential;
}

class ManagerHome extends StatefulWidget {
  const ManagerHome({super.key});
  @override State<ManagerHome> createState() => _ManagerHomeState();
}
class _ManagerHomeState extends State<ManagerHome> {
  int tab = 0, week = 1, wins = 0, draws = 0, losses = 0, points = 0, goalsFor = 0, goalsAgainst = 0;
  int budget = 85000000, wages = 2450000, boardTrust = 76, fanTrust = 81, managerXp = 0;
  String club = 'ريال مدريد', formation = '4-3-3', style = 'استحواذ', difficulty = 'متوسط';
  String news = 'الإدارة تتوقع المنافسة على لقب الدوري هذا الموسم.';
  final List<String> log = ['تم تعيينك مديرًا فنيًا للفريق الأول.', 'الإدارة: نريد التأهل إلى الأدوار النهائية في الكأس.'];
  final List<Player> squad = [
    Player('تيبو كورتوا','GK',90,34,18000000), Player('داني كارفاخال','RB',84,34,8000000),
    Player('أنطونيو روديغر','CB',87,33,25000000), Player('إيدر ميليتاو','CB',85,28,35000000),
    Player('فيرلان ميندي','LB',83,31,18000000), Player('فيديريكو فالفيردي','CM',89,28,90000000),
    Player('أوريلين تشواميني','DM',87,26,75000000), Player('جود بيلينغهام','AM',91,23,150000000),
    Player('رودريغو','RW',86,25,80000000), Player('كيليان مبابي','ST',93,28,180000000),
    Player('فينيسيوس جونيور','LW',92,26,170000000), Player('أندري لونين','GK',80,27,15000000),
    Player('إبراهيم دياز','AM',83,27,35000000), Player('أردا غولر','AM',82,21,45000000),
    Player('فران غارسيا','LB',79,27,12000000), Player('إندريك','ST',78,20,30000000),
  ];
  final List<Map<String,dynamic>> market = [
    {'name':'موهبة شابة','pos':'CM','rating':76,'age':19,'price':12000000},
    {'name':'مدافع سريع','pos':'CB','rating':82,'age':24,'price':28000000},
    {'name':'جناح مهاري','pos':'LW','rating':84,'age':22,'price':42000000},
    {'name':'مهاجم هداف','pos':'ST','rating':86,'age':25,'price':58000000},
  ];
  void note(String s) { log.insert(0, 'الأسبوع $week: $s'); if(log.length>12) log.removeLast(); }
  void simulateMatch() {
    final r = math.Random();
    final avg = squad.take(11).fold<int>(0,(s,p)=>s+p.rating) ~/ 11;
    final tacticalBonus = style == 'استحواذ' ? 2 : style == 'ضغط عالٍ' ? 1 : 0;
    final home = r.nextInt(4) + (avg + tacticalBonus >= 87 ? 1 : 0);
    final away = r.nextInt(4) + (difficulty == 'صعب' ? 1 : 0);
    goalsFor += home; goalsAgainst += away;
    String result;
    if(home>away){wins++;points+=3;boardTrust=(boardTrust+2).clamp(0,100).toInt();fanTrust=(fanTrust+3).clamp(0,100).toInt();result='فوز $home - $away';}
    else if(home==away){draws++;points++;result='تعادل $home - $away';}
    else {losses++;boardTrust=(boardTrust-5).clamp(0,100).toInt();fanTrust=(fanTrust-4).clamp(0,100).toInt();result='خسارة $home - $away';}
    week++; managerXp += 10;
    for(final p in squad){p.fitness=(p.fitness-(4+r.nextInt(9))).clamp(35,100).toInt();p.morale=(p.morale+(home>=away?2:-4)).clamp(20,100).toInt();}
    budget += 1200000;
    news = 'نتيجة المباراة: $result. تقييم الإدارة يتغير حسب الأداء.';
    note('المباراة: $result');
    setState((){});
    showDialog(context:context,builder:(c)=>AlertDialog(backgroundColor:panel,title:const Text('تقرير المباراة'),content:Column(mainAxisSize:MainAxisSize.min,crossAxisAlignment:CrossAxisAlignment.start,children:[Text(result,style:const TextStyle(fontSize:26,fontWeight:FontWeight.bold,color:lime)),const SizedBox(height:8),Text('الاستحواذ: ${48+ r.nextInt(22)}%'),Text('التسديدات: ${7+r.nextInt(10)}'),Text('دقة التمرير: ${78+r.nextInt(17)}%'),const SizedBox(height:8),const Text('تم تحديث الجدول والمعنويات والميزانية.')]),actions:[TextButton(onPressed:()=>Navigator.pop(c),child:const Text('متابعة'))]));
  }
  void train() {for(final p in squad.take(11)){p.fitness=(p.fitness-5).clamp(30,100).toInt();if(p.rating<p.potential && p.fitness>60 && math.Random().nextInt(3)==0)p.rating++;}note('انتهت الحصة التدريبية: تطور فني مع انخفاض بسيط في اللياقة.');setState((){});}
  void rest() {for(final p in squad){p.fitness=(p.fitness+14).clamp(0,100).toInt();p.morale=(p.morale+2).clamp(0,100).toInt();}note('يوم راحة: تحسنت لياقة اللاعبين ومعنوياتهم.');setState((){});}
  void buy(Map<String,dynamic> m) {final price=m['price'] as int;if(budget<price){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('الميزانية لا تكفي لإتمام الصفقة.')));return;}setState((){budget-=price;squad.add(Player(m['name'],m['pos'],m['rating'],m['age'],price,potential:math.min(95,m['rating']+12).toInt()));market.remove(m);note('تم التعاقد مع ${m['name']} مقابل ${money(price)}.');});}
  String money(int v){if(v>=1000000)return '€${(v/1000000).toStringAsFixed(v%10000000==0?0:1)}M';return '€${(v/1000).round()}K';}
  @override Widget build(BuildContext context){final pages=[dashboard(),squadPage(),tacticsPage(),trainingPage(),marketPage(),careerPage()];return Directionality(textDirection:TextDirection.rtl,child:Scaffold(body:SafeArea(child:Column(children:[header(),Expanded(child:AnimatedSwitcher(duration:const Duration(milliseconds:180),child:KeyedSubtree(key:ValueKey(tab),child:pages[tab])))])),bottomNavigationBar:NavigationBar(backgroundColor:panel,indicatorColor:lime.withOpacity(.18),selectedIndex:tab,onDestinationSelected:(v)=>setState(()=>tab=v),destinations:const [NavigationDestination(icon:Icon(Icons.dashboard_outlined),selectedIcon:Icon(Icons.dashboard),label:'الرئيسية'),NavigationDestination(icon:Icon(Icons.groups_outlined),selectedIcon:Icon(Icons.groups),label:'الفريق'),NavigationDestination(icon:Icon(Icons.sports_soccer_outlined),selectedIcon:Icon(Icons.sports_soccer),label:'التكتيك'),NavigationDestination(icon:Icon(Icons.fitness_center),label:'التدريب'),NavigationDestination(icon:Icon(Icons.swap_horiz),label:'الانتقالات'),NavigationDestination(icon:Icon(Icons.workspace_premium_outlined),label:'المسيرة')])));}
  Widget header()=>Container(padding:const EdgeInsets.fromLTRB(16,12,16,14),decoration:const BoxDecoration(gradient:LinearGradient(colors:[Color(0xFF183D2A),bg],begin:Alignment.topRight,end:Alignment.bottomLeft)),child:Row(children:[Container(width:44,height:44,decoration:BoxDecoration(color:lime,borderRadius:BorderRadius.circular(14)),child:const Icon(Icons.sports_soccer,color:bg,size:28)),const SizedBox(width:10),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('FAKHRI MANAGER',style:TextStyle(fontSize:16,fontWeight:FontWeight.w900,letterSpacing:1.1)),Text('$club  •  الموسم الأول  •  الأسبوع $week',style:const TextStyle(color:muted,fontSize:11))])),IconButton(onPressed:()=>showAboutDialog(context:context,applicationName:'Fakhri Manager',applicationVersion:'1.0.0',children:[const Text('لعبة إدارة كرة قدم تجريبية تعمل أوفلاين. النتائج واللاعبون داخل اللعبة محاكاة وليست بيانات مباشرة.')]),icon:const Icon(Icons.info_outline))]));
  Widget dashboard()=>ListView(padding:const EdgeInsets.all(14),children:[Container(height:200,decoration:BoxDecoration(borderRadius:BorderRadius.circular(22),gradient:const LinearGradient(colors:[Color(0xFF1D5A3A),Color(0xFF0C2117)])),child:Stack(children:[Positioned.fill(child:CustomPaint(painter:PitchPainter())),Positioned(right:16,top:14,child:Container(padding:const EdgeInsets.symmetric(horizontal:10,vertical:6),decoration:BoxDecoration(color:bg.withOpacity(.65),borderRadius:BorderRadius.circular(30)),child:const Text('3D TACTICAL VIEW',style:TextStyle(color:lime,fontSize:10,fontWeight:FontWeight.bold)))),Positioned(right:16,bottom:15,child:Text('خطة الفريق • $formation',style:const TextStyle(fontWeight:FontWeight.bold,fontSize:17,color:Colors.white))),Positioned(left:15,bottom:15,child:FilledButton.icon(onPressed:simulateMatch,style:FilledButton.styleFrom(backgroundColor:lime,foregroundColor:bg),icon:const Icon(Icons.play_arrow),label:const Text('العب المباراة')))])),const SizedBox(height:14),GridView.count(crossAxisCount:2,shrinkWrap:true,physics:const NeverScrollableScrollPhysics(),crossAxisSpacing:10,mainAxisSpacing:10,childAspectRatio:1.75,children:[metric('ميزانية الانتقالات',money(budget),Icons.account_balance_wallet),metric('ثقة الإدارة','$boardTrust%',Icons.business_center),metric('النقاط في الدوري','$points',Icons.leaderboard),metric('السجل','$wins فوز • $draws تعادل',Icons.emoji_events)]),const SizedBox(height:14),sectionTitle('مركز الأخبار',Icons.newspaper),card(child:Row(crossAxisAlignment:CrossAxisAlignment.start,children:[const Icon(Icons.campaign,color:lime),const SizedBox(width:10),Expanded(child:Text(news,style:const TextStyle(height:1.5)))])),const SizedBox(height:14),sectionTitle('إجراءات سريعة',Icons.bolt),Row(children:[Expanded(child:actionButton('حصة تدريب',Icons.fitness_center,train)),const SizedBox(width:8),Expanded(child:actionButton('راحة الفريق',Icons.bed,rest))]),const SizedBox(height:14),sectionTitle('آخر الأحداث',Icons.history),...log.take(4).map((e)=>card(child:Text(e,style:const TextStyle(color:muted))))]);
  Widget squadPage()=>ListView(padding:const EdgeInsets.all(14),children:[pageHeading('الفريق الأول','${squad.length} لاعب مسجل'),pitchCard(),const SizedBox(height:12),sectionTitle('قائمة اللاعبين',Icons.groups),...squad.map((p)=>card(child:Row(children:[CircleAvatar(backgroundColor:panel2,child:Text('${p.rating}',style:const TextStyle(color:lime,fontWeight:FontWeight.bold))),const SizedBox(width:10),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(p.name,style:const TextStyle(fontWeight:FontWeight.bold)),Text('${p.position} • ${p.age} سنة • قيمة ${money(p.value)}',style:const TextStyle(color:muted,fontSize:11))])),Column(crossAxisAlignment:CrossAxisAlignment.end,children:[Text('لياقة ${p.fitness}%',style:TextStyle(color:p.fitness<60?Colors.orange:lime,fontSize:11)),Text('معنويات ${p.morale}%',style:const TextStyle(color:muted,fontSize:10))]),PopupMenuButton<String>(onSelected:(v){setState((){if(v=='captain')note('تم اختيار ${p.name} قائدًا للفريق.');if(v=='sell'){budget+=(p.value*8~/10);squad.remove(p);note('تم بيع اللاعب ${p.name}.');}});},itemBuilder:(_)=>const [PopupMenuItem(value:'captain',child:Text('اختيار قائد')),PopupMenuItem(value:'sell',child:Text('بيع اللاعب'))])]))]);
  Widget tacticsPage()=>ListView(padding:const EdgeInsets.all(14),children:[pageHeading('غرفة التكتيك','اختر هوية الفريق قبل صافرة البداية'),pitchCard(),const SizedBox(height:16),sectionTitle('خطة اللعب',Icons.grid_4x4),Wrap(spacing:8,runSpacing:8,children:['4-3-3','4-2-3-1','4-4-2','3-5-2','5-3-2'].map((f)=>ChoiceChip(label:Text(f),selected:formation==f,onSelected:(_)=>setState(()=>formation=f),selectedColor:lime, labelStyle:TextStyle(color:formation==f?bg:Colors.white))).toList()),const SizedBox(height:16),sectionTitle('أسلوب الفريق',Icons.tune),...['استحواذ','ضغط عالٍ','هجمات مرتدة','دفاع متأخر'].map((s)=>RadioListTile<String>(value:s,groupValue:style,title:Text(s),activeColor:lime,contentPadding:EdgeInsets.zero,onChanged:(v)=>setState(()=>style=v!))),const SizedBox(height:8),sectionTitle('تعليمات المباراة',Icons.settings),card(child:const Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('العرض الهجومي: متوازن'),Text('خط الدفاع: متوسط'),Text('الضغط بعد فقدان الكرة: حسب أسلوب الفريق'),Text('ملاحظة: أثر التكتيك ممثل في محرك المحاكاة المبسط.')]))]);
  Widget trainingPage()=>ListView(padding:const EdgeInsets.all(14),children:[pageHeading('التدريب والجاهزية','خطط أسبوعية للاعبين'),sectionTitle('جلسات التدريب',Icons.fitness_center),card(child:Column(children:[trainingRow('تدريب تكتيكي','يحسن الانسجام والخطة',Icons.schema,()=>train()),const Divider(color:panel2),trainingRow('تدريب فني','فرصة لتطوير تقييم اللاعبين',Icons.sports_soccer,()=>train()),const Divider(color:panel2),trainingRow('تدريب بدني','تحسن محدود مع استهلاك اللياقة',Icons.bolt,()=>train()),const Divider(color:panel2),trainingRow('يوم راحة','استعادة اللياقة والمعنويات',Icons.hotel,rest)])),const SizedBox(height:14),sectionTitle('اللاعبون الأكثر إرهاقًا',Icons.warning_amber),...([...squad]..sort((a,b)=>a.fitness.compareTo(b.fitness))).take(5).map((p)=>card(child:Row(children:[Expanded(child:Text(p.name)),Text('${p.fitness}% لياقة',style:TextStyle(color:p.fitness<60?Colors.orange:lime))]))),const SizedBox(height:10),const Text('المؤشرات والأحداث تقديرية داخل اللعبة وليست تشخيصًا طبيًا.',style:TextStyle(color:muted,fontSize:11))]);
  Widget marketPage()=>ListView(padding:const EdgeInsets.all(14),children:[pageHeading('سوق الانتقالات','كشافون • صفقات • ميزانية'),card(child:Row(children:[const Icon(Icons.account_balance_wallet,color:lime,size:30),const SizedBox(width:12),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('ميزانية متاحة'),Text(money(budget),style:const TextStyle(fontSize:22,fontWeight:FontWeight.bold,color:lime))]))])),const SizedBox(height:12),sectionTitle('تقارير الكشافين',Icons.travel_explore),...market.map((m)=>card(child:Row(children:[Container(width:45,height:55,decoration:BoxDecoration(color:panel2,borderRadius:BorderRadius.circular(10)),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[Text('${m['rating']}',style:const TextStyle(fontSize:18,fontWeight:FontWeight.bold,color:lime)),Text(m['pos'],style:const TextStyle(fontSize:10,color:muted))])),const SizedBox(width:10),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(m['name'],style:const TextStyle(fontWeight:FontWeight.bold)),Text('العمر ${m['age']} • قيمة تقديرية ${money(m['price'])}',style:const TextStyle(color:muted,fontSize:11))])),FilledButton(onPressed:()=>buy(m),style:FilledButton.styleFrom(backgroundColor:lime,foregroundColor:bg),child:const Text('تفاوض'))]))),const SizedBox(height:10),const Text('أسماء سوق الانتقالات تجريبية. هذه ليست قاعدة بيانات حقيقية أو سوقًا مباشرًا.',style:TextStyle(color:muted,fontSize:11))]);
  Widget careerPage()=>ListView(padding:const EdgeInsets.all(14),children:[pageHeading('المسيرة المهنية','سمعة المدرب • أهداف الإدارة'),card(child:Column(children:[careerMetric('خبرة المدرب','$managerXp نقطة'),careerMetric('ثقة مجلس الإدارة','$boardTrust / 100'),careerMetric('رضا الجماهير','$fanTrust / 100'),careerMetric('سجل المباريات','$wins فوز • $draws تعادل • $losses خسارة'),careerMetric('الأهداف المسجلة','$goalsFor'),careerMetric('الأهداف المستقبلة','$goalsAgainst')])),const SizedBox(height:14),sectionTitle('أهداف الموسم',Icons.flag),card(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[objective('المنافسة على لقب الدوري',points>=20),objective('الوصول إلى نصف نهائي الكأس',false),objective('الحفاظ على ثقة الإدارة',boardTrust>=65)])),const SizedBox(height:14),sectionTitle('إدارة النادي',Icons.business),card(child:Column(children:[ListTile(leading:const Icon(Icons.stadium,color:lime),title:const Text('تطوير مرافق التدريب'),subtitle:const Text('التكلفة: €8M'),trailing:TextButton(onPressed:()=>spend(8000000,'تم تطوير مرافق التدريب.'),child:const Text('تطوير'))),ListTile(leading:const Icon(Icons.school,color:lime),title:const Text('توسيع أكاديمية الشباب'),subtitle:const Text('التكلفة: €5M'),trailing:TextButton(onPressed:()=>spend(5000000,'تم توسيع أكاديمية الشباب.'),child:const Text('تطوير')))])),const SizedBox(height:14),sectionTitle('سجل الأحداث',Icons.history),...log.map((e)=>card(child:Text(e,style:const TextStyle(color:muted))))]);
  void spend(int amount,String message){if(budget<amount){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('لا توجد ميزانية كافية.')));return;}setState(()=>budget-=amount);note(message);}
  Widget pitchCard()=>Container(height:250,decoration:BoxDecoration(borderRadius:BorderRadius.circular(20),border:Border.all(color:Colors.white10),gradient:const LinearGradient(colors:[Color(0xFF1D5B3A),Color(0xFF103522)])),child:CustomPaint(painter:PitchPainter(formation:formation),child:const SizedBox.expand()));
  Widget pageHeading(String title,String subtitle)=>Padding(padding:const EdgeInsets.only(bottom:14),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(title,style:const TextStyle(fontSize:25,fontWeight:FontWeight.w900)),const SizedBox(height:3),Text(subtitle,style:const TextStyle(color:muted))]));
  Widget sectionTitle(String t,IconData i)=>Padding(padding:const EdgeInsets.only(bottom:8,top:2),child:Row(children:[Icon(i,color:lime,size:19),const SizedBox(width:8),Text(t,style:const TextStyle(fontWeight:FontWeight.bold,fontSize:16))]));
  Widget card({required Widget child})=>Container(margin:const EdgeInsets.only(bottom:8),padding:const EdgeInsets.all(12),decoration:BoxDecoration(color:panel,borderRadius:BorderRadius.circular(15),border:Border.all(color:Colors.white.withOpacity(.04))),child:child);
  Widget metric(String title,String value,IconData icon)=>Container(padding:const EdgeInsets.all(12),decoration:BoxDecoration(color:panel,borderRadius:BorderRadius.circular(16)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[Icon(icon,color:lime,size:20),Text(value,style:const TextStyle(fontSize:18,fontWeight:FontWeight.w900)),Text(title,style:const TextStyle(fontSize:11,color:muted))]));
  Widget actionButton(String t,IconData i,VoidCallback f)=>FilledButton.tonalIcon(onPressed:f,icon:Icon(i),label:Text(t),style:FilledButton.styleFrom(backgroundColor:panel2,foregroundColor:lime,padding:const EdgeInsets.symmetric(vertical:14)));
  Widget trainingRow(String title,String sub,IconData icon,VoidCallback f)=>ListTile(contentPadding:EdgeInsets.zero,leading:Container(padding:const EdgeInsets.all(10),decoration:BoxDecoration(color:panel2,borderRadius:BorderRadius.circular(12)),child:Icon(icon,color:lime)),title:Text(title),subtitle:Text(sub,style:const TextStyle(fontSize:11,color:muted)),trailing:IconButton(onPressed:f,icon:const Icon(Icons.play_circle_fill,color:lime,size:30)));
  Widget careerMetric(String t,String v)=>Padding(padding:const EdgeInsets.symmetric(vertical:8),child:Row(children:[Expanded(child:Text(t,style:const TextStyle(color:muted))),Text(v,style:const TextStyle(fontWeight:FontWeight.bold,color:lime))]));
  Widget objective(String t,bool done)=>Padding(padding:const EdgeInsets.symmetric(vertical:7),child:Row(children:[Icon(done?Icons.check_circle:Icons.radio_button_unchecked,color:done?lime:muted),const SizedBox(width:8),Expanded(child:Text(t)),Text(done?'مكتمل':'مستمر',style:TextStyle(color:done?lime:muted,fontSize:11))]));
}

class PitchPainter extends CustomPainter {
  PitchPainter({this.formation='4-3-3'});
  final String formation;
  @override void paint(Canvas canvas,Size size){final rect=Rect.fromLTWH(8,8,size.width-16,size.height-16);final fill=Paint()..color=const Color(0xFF2A7047);canvas.drawRRect(RRect.fromRectAndRadius(rect,const Radius.circular(15)),fill);final line=Paint()..color=Colors.white.withOpacity(.55)..style=PaintingStyle.stroke..strokeWidth=1.3;canvas.drawRRect(RRect.fromRectAndRadius(rect.deflate(12),const Radius.circular(8)),line);canvas.drawLine(Offset(size.width/2,20),Offset(size.width/2,size.height-20),line);canvas.drawCircle(Offset(size.width/2,size.height/2),size.height*.12,line);canvas.drawRect(Rect.fromCenter(center:Offset(size.width/2,20),width:size.width*.3,height:25),line);canvas.drawRect(Rect.fromCenter(center:Offset(size.width/2,size.height-20),width:size.width*.3,height:25),line);
    final rows=formation=='3-5-2'?[3,5,2]:formation=='4-4-2'?[4,4,2]:formation=='4-2-3-1'?[4,2,3,1]:formation=='5-3-2'?[5,3,2]:[4,3,3];
    final ys=List<double>.generate(rows.length,(i)=>size.height-38-(i*(size.height-76)/(rows.length-1==0?1:rows.length-1)));
    for(int row=0;row<rows.length;row++){final count=rows[row];for(int i=0;i<count;i++){final x=size.width*(.14+(.72*(i+1)/(count+1)));final y=ys[row];final center=Offset(x,y);canvas.drawCircle(center,9,Paint()..color=lime);canvas.drawCircle(center,9,line);final tp=TextPainter(text:const TextSpan(text:'●',style:TextStyle(color:bg,fontSize:9)),textDirection:TextDirection.ltr)..layout();tp.paint(canvas,Offset(x-tp.width/2,y-tp.height/2));}}
  }
  @override bool shouldRepaint(covariant PitchPainter old)=>old.formation!=formation;
}