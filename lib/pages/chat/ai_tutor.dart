class AiTutor {
  AiTutor._();

  static String welcome(String code) {
    switch (code) {
      case 'ru':
        return 'Привет! Я Zaizen AI. Можем учить японский: хирагана, фразы, кандзи.';
      case 'en':
        return 'Hi! I am Zaizen AI. Ask me hiragana, phrases, or kanji.';
      case 'ja':
        return 'こんにちは！Zaizen AI です。ひらがな・会話・漢字を聞いてください。';
      default:
        return "Salom! Men Zaizen AI. Hiragana, iboralar yoki kanji so'rang.";
    }
  }

  static List<String> hints(String code) {
    switch (code) {
      case 'ru':
        return ['Как сказать привет', 'Как читать あ', 'Представиться'];
      case 'en':
        return ['How to say hello', 'How to read あ', 'Introduce myself'];
      case 'ja':
        return ['あいさつは？', 'あの読み方', '自己紹介'];
      default:
        return ['Salom qanday?', 'あ qanday o\'qiladi?', "O'zimni tanishtirish"];
    }
  }

  static String reply(String input, String code) {
    final t = input.toLowerCase().trim();
    final hello = t.contains('salom') || t.contains('hello') || t.contains('прив') || t.contains('こんにち') || t.contains('hi');
    final a = t.contains('あ') || t.contains('hiragana') || t.contains('хира') || t.contains("o'qil") || t.contains('read');
    final name = t.contains('ism') || t.contains('name') || t.contains('имя') || t.contains('自己') || t.contains('tanisht');
    final thanks = t.contains('rahmat') || t.contains('thank') || t.contains('спас') || t.contains('ありがと');

    switch (code) {
      case 'ru':
        if (hello) return 'こんничива (konnichiwa) — дневное приветствие.\nおはよう (ohayou) — утром.';
        if (a) return 'あ читается «а». Это первая хирагана. Дальше: い (i), う (u), え (e), お (o).';
        if (name) return '私は [имя] です。 (watashi wa ... desu) — «меня зовут ...».';
        if (thanks) return 'ありがとう (arigatou) — спасибо. Вежливо: ありがとうございます.';
        return 'Напишите фразу или хирагану — разберу по частям.';
      case 'en':
        if (hello) return 'こんничива (konnichiwa) — hello.\nおはよう (ohayou) — good morning.';
        if (a) return 'あ is read “a”. Next: い (i), う (u), え (e), お (o).';
        if (name) return '私は [name] です。 (watashi wa ... desu) — “My name is ...”.';
        if (thanks) return 'ありがとう (arigatou) — thank you. Polite: ありがとうございます.';
        return 'Send a phrase or a hiragana character and I will break it down.';
      case 'ja':
        if (hello) return 'こんничиваは日中のあいさつ。おはようは朝のあいさつです。';
        if (a) return '「あ」は「a」と読みます。次は い i、う u、え e、お o です。';
        if (name) return '「私は【名前】です」で自己紹介できます。';
        if (thanks) return 'ありがとう。ていねいにはありがとうございます。';
        return '文句やひらがなを送ってください。解説します。';
      default:
        if (hello) return 'こんничива (konnichiwa) — kunlik salom.\nおはよう (ohayou) — ertalabki salom.';
        if (a) return 'あ «a» deb o\'qiladi. Keyingilar: い (i), う (u), え (e), お (o).';
        if (name) return '私は [ism] です。 (watashi wa ... desu) — «Mening ismim ...».';
        if (thanks) return 'ありがとう (arigatou) — rahmat. Hurmatli: ありがとうございます.';
        return "Iborani yoki hiragana belgisini yozing — bo'laklab tushuntiraman.";
    }
  }
}
