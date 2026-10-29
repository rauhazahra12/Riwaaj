import 'package:flutter/material.dart';

void main() => runApp(const App());
const paper = Color(0xfff8f3e9),
    ink = Color(0xff211e21),
    pink = Color(0xfff1b8cf),
    red = Color(0xffe84b23),
    blue = Color(0xff2c4dc4),
    gold = Color(0xfff0a91b),
    green = Color(0xff163c32),
    muted = Color(0xff756c69);

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext c) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: paper,
      colorScheme: ColorScheme.fromSeed(seedColor: red),
      fontFamily: 'Georgia',
    ),
    home: const Shell(),
  );
}

class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => S();
}

class S extends State<Shell> {
  String page = 'splash', cat = 'All';
  int tab = 0, step = 0;
  bool verified = false, accepted = false;
  final fav = <String>{'Ivory nikkah set'};
  void go(String p) => setState(() => page = p);
  void nav(int i) {
    setState(() {
      tab = i;
      page = ['home', 'search', 'add', 'chats', 'profile'][i];
    });
  }

  @override
  Widget build(BuildContext c) {
    final body = switch (page) {
      'splash' => splash(),
      'onboard' => onboard(),
      'login' => login(),
      'verify' => verify(),
      'home' => home(),
      'search' => search(),
      'detail' => detail(),
      'booking' => booking(),
      'chats' => chats(),
      'chat' => chat(),
      'bookings' => bookings(),
      'add' => add(),
      'profile' => profile(),
      'dashboard' => dashboard(),
      'saved' => saved(),
      _ => home(),
    };
    final show = ![
      'splash',
      'onboard',
      'login',
      'verify',
      'detail',
      'booking',
      'chat',
      'dashboard',
    ].contains(page);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(child: body),
            if (show) Align(alignment: Alignment.bottomCenter, child: navBar()),
          ],
        ),
      ),
    );
  }

  Widget splash() => Stack(
    children: [
      Positioned.fill(
        child: CustomPaint(painter: Dress(color: blue)),
      ),
      Positioned(
        left: -60,
        top: 280,
        child: Container(
          width: 270,
          height: 320,
          decoration: BoxDecoration(
            color: pink,
            borderRadius: BorderRadius.circular(140),
          ),
        ),
      ),
      const Positioned(
        left: 24,
        top: 44,
        child: Text(
          'THE WARDROBE, REIMAGINED',
          style: TextStyle(fontSize: 10, letterSpacing: 1.4),
        ),
      ),
      const Positioned(
        left: 22,
        top: 86,
        child: Text(
          'Riwaaj',
          style: TextStyle(
            fontSize: 70,
            fontWeight: FontWeight.bold,
            letterSpacing: -5,
          ),
        ),
      ),
      const Positioned(
        left: 108,
        top: 156,
        child: Text(
          'wear a story',
          style: TextStyle(fontFamily: 'cursive', fontSize: 24, color: red),
        ),
      ),
      Positioned(
        left: 24,
        right: 24,
        bottom: 65,
        child: Column(
          children: [
            const Text(
              'Wear the wow.\nNot the bill.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 22),
            btn('Enter the wardrobe', () => go('onboard')),
            TextButton(
              onPressed: () => go('login'),
              child: const Text(
                'Already a member? Log in',
                style: TextStyle(color: ink),
              ),
            ),
          ],
        ),
      ),
    ],
  );
  Widget onboard() => pad(
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: TextButton(
            onPressed: () => go('login'),
            child: const Text('Skip'),
          ),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: pink,
              borderRadius: BorderRadius.circular(150),
            ),
            child: CustomPaint(painter: Dress(color: blue)),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Rent the wow, skip the cost.',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        const Text(
          'Beautiful occasionwear, ready for your next big day.',
          style: TextStyle(color: muted),
        ),
        const SizedBox(height: 20),
        btn('Let’s go', () => go('login')),
      ],
    ),
  );
  Widget login() => pad(
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        back(() => go('splash')),
        const SizedBox(height: 28),
        const Text(
          'Your next look\nstarts here.',
          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: btn('Log in', () => {})),
            const SizedBox(width: 8),
            Expanded(child: outline('Sign up', () => {})),
          ],
        ),
        const SizedBox(height: 18),
        field('Full name', 'Ayesha Khan'),
        field('Email address', 'ayesha@email.com'),
        field('Password', 'At least 8 characters'),
        const Spacer(),
        btn('Continue', () => go('verify')),
        Center(
          child: TextButton(
            onPressed: () => go('verify'),
            child: const Text('Continue with phone →'),
          ),
        ),
      ],
    ),
  );
  Widget verify() => pad(
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        back(() => go('login')),
        const SizedBox(height: 24),
        const Text(
          'A little check-in.',
          style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
        ),
        const Text(
          'Verify your number to build trust in Riwaaj.',
          style: TextStyle(color: muted),
        ),
        const SizedBox(height: 24),
        const Text('6-DIGIT CODE'),
        const SizedBox(height: 8),
        Row(
          children: List.generate(
            6,
            (i) => Expanded(
              child: Container(
                height: 50,
                margin: const EdgeInsets.only(right: 5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(i < 3 ? '${[4, 2, 8][i]}' : ''),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        field('CNIC number', '12345-1234567-1'),
        const Spacer(),
        btn(
          verified ? 'Verified ✓' : 'Verify & continue',
          () => setState(() => verified = true),
        ),
        if (verified) btn('Continue to Riwaaj', () => go('home')),
      ],
    ),
  );
  Widget home() => pad(
    ListView(
      children: [
        const Text(
          'MONDAY · 12 MAY',
          style: TextStyle(fontSize: 10, letterSpacing: 1.4, color: muted),
        ),
        const SizedBox(height: 6),
        const Text(
          'Shaadi ready,\nAyesha?',
          style: TextStyle(
            fontSize: 29,
            fontWeight: FontWeight.bold,
            height: 1.05,
          ),
        ),
        const SizedBox(height: 14),
        searchField(() => go('search')),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
                ['All', 'Bridal', 'Lehenga', 'Saree', 'Sherwani', 'Formal']
                    .map(
                      (x) => chip(x, cat == x, () => setState(() => cat = x)),
                    )
                    .toList(),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Wedding season edit',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const Text(
          'Good things are meant to be shared.',
          style: TextStyle(fontFamily: 'cursive', fontSize: 18, color: red),
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  card('Ruby farshi lehenga', 'PKR 12,500', 0),
                  card('Ivory nikkah set', 'PKR 9,500', 1),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                children: [
                  card('Sunlit mayun lehenga', 'PKR 6,500', 2),
                  card('Midnight gharara', 'PKR 8,000', 3),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
  Widget search() => pad(
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Find your look.',
          style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        searchField(() => {}),
        const SizedBox(height: 16),
        const Text(
          'RECENT SEARCHES',
          style: TextStyle(color: muted, fontSize: 11),
        ),
        Wrap(
          children: [
            'Lehenga · Lahore',
            'Mehndi green',
            'Nikkah formal',
          ].map((x) => chip(x, false, () => {})).toList(),
        ),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Trending near you',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            outline('Filters', () => filters()),
          ],
        ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: .68,
            children: [
              card('Ruby farshi lehenga', 'PKR 12,500', 0),
              card('Mayun lehenga', 'PKR 6,500', 2),
              card('Ivory nikkah set', 'PKR 9,500', 1),
              card('Midnight gharara', 'PKR 8,000', 3),
            ],
          ),
        ),
      ],
    ),
  );
  Widget detail() => Column(
    children: [
      Expanded(
        child: Stack(
          children: [
            Positioned.fill(child: Art(0)),
            Positioned(
              top: 8,
              left: 8,
              child: round(Icons.arrow_back, () => go('home')),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: round(
                Icons.favorite,
                () => setState(() => fav.add('Ruby farshi lehenga')),
              ),
            ),
          ],
        ),
      ),
      Expanded(
        child: pad(
          ListView(
            children: [
              const Text('THE WEDDING EDIT'),
              const Text(
                'Ruby farshi lehenga',
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
              const Text('PKR 12,500 / day · Refundable deposit PKR 25,000'),
              Wrap(
                children: [
                  'XS',
                  'S',
                  'M',
                  'L',
                  'XL',
                ].map((x) => chip(x, x == 'M', () => {})).toList(),
              ),
              const Text(
                'Hand-finished ruby raw silk with antique gold threadwork. A statement piece, ready for its next story.',
              ),
              info(Icons.verified, 'Maha Rizvi · Verified', 'Lahore · ★ 4.9'),
              info(Icons.calendar_month, 'Availability', '12–20 December'),
              Row(
                children: [
                  Expanded(child: outline('Chat with owner', () => go('chat'))),
                  Expanded(child: btn('Request to rent', () => go('booking'))),
                ],
              ),
            ],
          ),
        ),
      ),
    ],
  );
  Widget booking() => pad(
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        back(() => go('detail')),
        const Text(
          'Make it yours.',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        const Text(
          'Choose dates and send a request.',
          style: TextStyle(color: muted),
        ),
        info(Icons.checkroom, 'Ruby farshi lehenga', 'PKR 12,500 / day'),
        const Text(
          'DECEMBER 2026',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        calendar(),
        field('Your size', 'Medium · M'),
        field('Note to Maha', 'Hello! I would love to rent this.'),
        const Spacer(),
        const Text(
          '3 days × PKR 12,500             PKR 37,500\nRiwaaj service fee (15%)        PKR 5,625\nRefundable deposit              PKR 25,000\nTOTAL                               PKR 68,125',
          style: TextStyle(height: 1.8),
        ),
        btn('Send rental request', () => go('bookings')),
      ],
    ),
  );
  Widget chats() => pad(
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your conversations',
          style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
        ),
        searchField(() => {}),
        Expanded(
          child: ListView(
            children: [
              chatTile(
                'Maha Rizvi',
                'Ruby farshi lehenga',
                'Yes, it’s free for those dates!',
                '10:42',
              ),
              chatTile(
                'Noor Boutique',
                'Ivory nikkah set',
                'I can share more photos.',
                'Yesterday',
              ),
              chatTile(
                'Areeba S.',
                'Sunlit mayun lehenga',
                'Thank you so much!',
                'Mon',
              ),
            ],
          ),
        ),
      ],
    ),
  );
  Widget chat() => Column(
    children: [
      ListTile(
        leading: back(() => go('chats')),
        title: const Text('Maha Rizvi'),
        subtitle: const Text('Verified · usually replies quickly'),
      ),
      info(
        Icons.checkroom,
        'Ruby farshi lehenga · PKR 12,500/day',
        'Lahore · View outfit',
      ),
      Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(12),
        color: const Color(0xffe5eee5),
        child: const Text(
          'Keep chats and meetups on Riwaaj. Never share payment details here.',
          style: TextStyle(color: green, fontSize: 11),
        ),
      ),
      Expanded(
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            bubble('Assalam-o-alaikum! Is it available 12–15 Dec?', true),
            bubble('Walaikum assalam! Yes, it is available.', false),
            bubble('That would be lovely, thank you!', true),
            info(
              Icons.event,
              'Rental request · 12–15 Dec',
              'PKR 68,125 total · size M',
            ),
            if (!accepted)
              btn('Accept request', () => setState(() => accepted = true))
            else
              const Text('Request accepted ✓', style: TextStyle(color: green)),
          ],
        ),
      ),
      TextField(
        decoration: InputDecoration(
          hintText: 'Message Maha…',
          prefixIcon: const Icon(Icons.add),
          suffixIcon: const Icon(Icons.send, color: red),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    ],
  );
  Widget bookings() => pad(
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'the outfit diary',
          style: TextStyle(fontFamily: 'cursive', fontSize: 20, color: red),
        ),
        const Text(
          'My bookings',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Expanded(child: btn('I’m renting', () => {})),
            Expanded(child: outline('I’m lending', () => {})),
          ],
        ),
        Expanded(
          child: ListView(
            children: [
              bookCard('Ruby farshi lehenga', 'Accepted', '12–15 Dec'),
              bookCard('Ivory nikkah set', 'Pending', '22–23 Dec'),
              bookCard('Sunlit mayun lehenga', 'Returned', '04 Nov'),
            ],
          ),
        ),
      ],
    ),
  );
  Widget add() => pad(
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'List an outfit',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            'Photos',
            'Details',
            'Price & dates',
          ].map((x) => Expanded(child: Text(x))).toList(),
        ),
        const SizedBox(height: 22),
        Text(
          ['Add your best angles.', 'Tell its story.', 'Set your terms.'][step],
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: step == 0
              ? GridView.count(
                  crossAxisCount: 2,
                  children: List.generate(
                    5,
                    (_) => Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: pink,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.add_a_photo_outlined),
                    ),
                  ),
                )
              : Column(
                  children: [
                    field('Listing title', 'Ruby farshi lehenga'),
                    field('Designer / boutique', 'Designer name'),
                    field('Category', 'Bridal lehenga'),
                    field('Size', 'Medium'),
                    field('Price per day', 'PKR 12,500'),
                    field('Pickup city', 'Lahore'),
                  ],
                ),
        ),
        btn(
          step < 2 ? 'Continue' : 'Publish listing',
          () => setState(() => step = step < 2 ? step + 1 : 0),
        ),
      ],
    ),
  );
  Widget profile() => pad(
    ListView(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: round(Icons.settings, () => {}),
        ),
        const Center(
          child: CircleAvatar(
            radius: 42,
            backgroundColor: pink,
            child: Text('AK', style: TextStyle(fontSize: 22, color: ink)),
          ),
        ),
        const Center(
          child: Text(
            'Ayesha Khan',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
          ),
        ),
        const Center(
          child: Text(
            '✓ Verified · Lahore, Pakistan',
            style: TextStyle(color: green),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            stat('6', 'Listings'),
            stat('14', 'Rentals'),
            stat('4.9', 'Rating ★'),
          ],
        ),
        const Text(
          'My listings',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        info(Icons.checkroom, 'Black & gold gharara', 'PKR 8,000/day · Active'),
        info(Icons.checkroom, 'Ivory nikkah set', 'PKR 9,500/day · Active'),
        menu(
          Icons.store,
          'Boutique dashboard',
          'Manage your business',
          () => go('dashboard'),
        ),
        menu(
          Icons.bookmark,
          'Saved looks',
          'Your maybe pile',
          () => go('saved'),
        ),
        menu(
          Icons.calendar_month,
          'My bookings',
          'Rental timeline',
          () => go('bookings'),
        ),
        menu(Icons.logout, 'Log out', '', () => go('login')),
      ],
    ),
  );
  Widget dashboard() => pad(
    ListView(
      children: [
        ListTile(
          leading: back(() => go('profile')),
          title: const Text('NOOR BOUTIQUE · LAHORE'),
        ),
        const Text(
          'Looking good,\nNoor.',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: green,
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Text(
            'MONTHLY EARNINGS\nPKR 84.5k\n↑ 18% from last month',
            style: TextStyle(color: Colors.white, height: 1.5),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: info(
                Icons.mark_chat_unread,
                '12 requests',
                '4 need replies',
              ),
            ),
            Expanded(child: info(Icons.visibility, '2.8k views', '↑ 24%')),
          ],
        ),
        const Text(
          'Your rack',
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
        ),
        info(Icons.checkroom, 'Ruby farshi lehenga', '12 bookings · Active'),
        info(Icons.checkroom, 'Ivory nikkah ensemble', '8 bookings · Active'),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: pink,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              const Text(
                'Be seen · Promote an outfit',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              const Text('3 · 7 · 14 days'),
              btn('Choose an outfit', () => {}),
            ],
          ),
        ),
        const Text(
          'Plans   Free 15%     Silver 10%     Gold 7%',
          style: TextStyle(color: green),
        ),
      ],
    ),
  );
  Widget saved() => pad(
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'the maybe pile',
          style: TextStyle(fontFamily: 'cursive', fontSize: 21, color: red),
        ),
        const Text(
          'Saved looks',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        Text(
          '${fav.length} outfits saved for your next main-character moment.',
          style: const TextStyle(color: muted),
        ),
        Expanded(
          child: fav.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.favorite_border, size: 55, color: red),
                      const Text(
                        'Your dream rack starts here.',
                        style: TextStyle(fontSize: 22),
                      ),
                      btn('Find a look', () => go('home')),
                    ],
                  ),
                )
              : GridView.count(
                  crossAxisCount: 2,
                  children: fav.map((x) => card(x, 'PKR 9,500', 1)).toList(),
                ),
        ),
      ],
    ),
  );
  Widget navBar() => Container(
    height: 67,
    margin: const EdgeInsets.fromLTRB(14, 0, 14, 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25),
      boxShadow: [BoxShadow(color: ink.withValues(alpha: .12), blurRadius: 18)],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        navItem(Icons.home_outlined, 'Home', 0),
        navItem(Icons.search, 'Search', 1),
        InkWell(
          onTap: () => nav(2),
          child: const CircleAvatar(
            backgroundColor: red,
            child: Icon(Icons.add, color: Colors.white),
          ),
        ),
        navItem(Icons.chat_bubble_outline, 'Chats', 3),
        navItem(Icons.person_outline, 'Profile', 4),
      ],
    ),
  );
  Widget navItem(IconData i, String t, int n) => InkWell(
    onTap: () => nav(n),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(i, color: tab == n ? red : muted),
        Text(t, style: TextStyle(fontSize: 9, color: tab == n ? red : muted)),
      ],
    ),
  );
  Widget pad(Widget x) =>
      Padding(padding: const EdgeInsets.fromLTRB(20, 14, 20, 90), child: x);
  Widget btn(String t, VoidCallback f) => SizedBox(
    width: double.infinity,
    height: 49,
    child: FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: red,
        foregroundColor: Colors.white,
      ),
      onPressed: f,
      child: Text(
        t,
        style: const TextStyle(
          fontFamily: 'Arial',
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
  Widget outline(String t, VoidCallback f) => OutlinedButton(
    onPressed: f,
    style: OutlinedButton.styleFrom(
      foregroundColor: ink,
      side: const BorderSide(color: ink),
    ),
    child: Text(t),
  );
  Widget back(VoidCallback f) => IconButton(
    onPressed: f,
    icon: const Icon(Icons.arrow_back_ios_new, size: 18),
  );
  Widget field(String a, String b) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(a, style: const TextStyle(fontSize: 11, color: muted)),
        TextField(
          decoration: InputDecoration(
            hintText: b,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    ),
  );
  Widget searchField(VoidCallback f) => TextField(
    readOnly: true,
    onTap: f,
    decoration: InputDecoration(
      hintText: 'Search outfits, occasions, cities',
      prefixIcon: const Icon(Icons.search),
      suffixIcon: IconButton(onPressed: filters, icon: const Icon(Icons.tune)),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
    ),
  );
  Widget chip(String t, bool active, VoidCallback f) => Padding(
    padding: const EdgeInsets.only(right: 6),
    child: ActionChip(
      onPressed: f,
      label: Text(
        t,
        style: TextStyle(fontSize: 11, color: active ? Colors.white : ink),
      ),
      backgroundColor: active ? ink : Colors.white,
      shape: const StadiumBorder(),
    ),
  );
  Widget round(IconData i, VoidCallback f) => CircleAvatar(
    backgroundColor: Colors.white,
    child: IconButton(
      onPressed: f,
      icon: Icon(i, color: ink, size: 19),
    ),
  );
  Widget card(String t, String price, int i) => InkWell(
    onTap: () => go('detail'),
    child: Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 215,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Stack(
                children: [
                  Positioned.fill(child: Art(i)),
                  Positioned(
                    right: 5,
                    top: 5,
                    child: round(
                      Icons.favorite,
                      () => setState(
                        () => fav.contains(t) ? fav.remove(t) : fav.add(t),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(
            t,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          Text('$price / day', style: const TextStyle(fontSize: 11)),
          const Text(
            '✦ Lahore · Size M',
            style: TextStyle(fontSize: 9, color: muted),
          ),
        ],
      ),
    ),
  );
  Widget info(IconData i, String t, String s) => Container(
    margin: const EdgeInsets.symmetric(vertical: 5),
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(17),
    ),
    child: Row(
      children: [
        Icon(i, color: green),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Text(s, style: const TextStyle(color: muted, fontSize: 11)),
            ],
          ),
        ),
        const Icon(Icons.chevron_right),
      ],
    ),
  );
  Widget stat(String a, String b) => Column(
    children: [
      Text(
        a,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      Text(b, style: const TextStyle(fontSize: 10, color: muted)),
    ],
  );
  Widget menu(IconData i, String t, String s, VoidCallback f) => ListTile(
    onTap: f,
    leading: Icon(i, color: green),
    title: Text(
      t,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
    ),
    subtitle: s.isEmpty ? null : Text(s),
    trailing: const Icon(Icons.chevron_right),
  );
  Widget chatTile(String n, String outfit, String msg, String time) => ListTile(
    onTap: () => go('chat'),
    leading: CircleAvatar(backgroundColor: pink, child: Text(n[0])),
    title: Text(n),
    subtitle: Text('$outfit\n$msg'),
    trailing: Text(time, style: const TextStyle(fontSize: 10)),
  );
  Widget bubble(String t, bool sent) => Align(
    alignment: sent ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.all(7),
      padding: const EdgeInsets.all(13),
      constraints: const BoxConstraints(maxWidth: 280),
      decoration: BoxDecoration(
        color: sent ? red : Colors.white,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Text(t, style: TextStyle(color: sent ? Colors.white : ink)),
    ),
  );
  Widget bookCard(String t, String st, String dt) => InkWell(
    onTap: timeline,
    child: info(Icons.checkroom, '$st · $dt', '$t · PKR 68,125'),
  );
  Widget calendar() => Container(
    height: 175,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(
        35,
        (i) => Container(
          width: 29,
          height: 25,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: i >= 13 && i <= 15 ? pink : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text('${i + 1}', style: const TextStyle(fontSize: 10)),
        ),
      ),
    ),
  );
  void filters() => showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (c) => Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Narrow the edit',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Text('BUDGET · PKR'),
          RangeSlider(
            values: RangeValues(5000, 25000),
            min: 1000,
            max: 50000,
            onChanged: null,
          ),
          const Text('SIZE'),
          Wrap(
            children: [
              'XS',
              'S',
              'M',
              'L',
              'XL',
              'XXL',
            ].map((x) => chip(x, x == 'M', () => {})).toList(),
          ),
          field('City', 'Lahore'),
          btn('Show outfits', () => Navigator.pop(c)),
        ],
      ),
    ),
  );
  void timeline() => showModalBottomSheet(
    context: context,
    builder: (c) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Rental journey'),
        const ListTile(title: Text('Request sent')),
        const ListTile(title: Text('Accepted by owner')),
        btn('Message owner', () => Navigator.pop(c)),
      ],
    ),
  );
}

class Art extends StatelessWidget {
  const Art(this.i, {super.key});
  final int i;
  @override
  Widget build(BuildContext c) => Container(
    color: [
      pink,
      const Color(0xffe5e5dc),
      const Color(0xfff2d27f),
      const Color(0xff273a48),
    ][i % 4],
    child: CustomPaint(
      painter: Dress(color: [red, green, blue, gold][i % 4]),
      child: const SizedBox.expand(),
    ),
  );
}

class Dress extends CustomPainter {
  Dress({this.color = blue});
  final Color color;
  @override
  void paint(Canvas c, Size s) {
    final x = s.width * .5, y = s.height * .22;
    final inkP = Paint()
      ..color = ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    final p = Paint()..color = color;
    final h = Path()
      ..moveTo(x - 40, y + 15)
      ..quadraticBezierTo(x, y - 6, x + 40, y + 15)
      ..moveTo(x, y + 6)
      ..cubicTo(x - 4, y - 4, x + 5, y - 13, x + 10, y - 14);
    c.drawPath(h, inkP);
    final b = Path()
      ..moveTo(x - 23, y + 21)
      ..lineTo(x - 15, y + 62)
      ..lineTo(x + 15, y + 62)
      ..lineTo(x + 23, y + 21)
      ..lineTo(x + 10, y + 14)
      ..lineTo(x, y + 28)
      ..lineTo(x - 10, y + 14)
      ..close();
    c.drawPath(b, p);
    c.drawPath(b, inkP);
    final sk = Path()
      ..moveTo(x - 15, y + 62)
      ..lineTo(x + 15, y + 62)
      ..cubicTo(x + 24, y + 108, x + 54, y + 152, x + 70, y + 188)
      ..quadraticBezierTo(x, y + 200, x - 70, y + 188)
      ..cubicTo(x - 54, y + 152, x - 24, y + 108, x - 15, y + 62)
      ..close();
    c.drawPath(sk, p);
    c.drawPath(sk, inkP);
    c.drawPath(
      Path()
        ..moveTo(x - 50, y + 173)
        ..quadraticBezierTo(x, y + 188, x + 50, y + 173),
      Paint()
        ..color = gold
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
    final r = Paint()
      ..color = red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    c.drawPath(
      Path()
        ..moveTo(x + 40, y + 25)
        ..cubicTo(x + 100, y + 8, x + 78, y + 98, x + 130, y + 83)
        ..cubicTo(x + 165, y + 70, x + 133, y + 158, x + 180, y + 142),
      r,
    );
  }

  @override
  bool shouldRepaint(covariant Dress old) => old.color != color;
}
