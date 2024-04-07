class Interest {
  const Interest(this.text, this.interestsFirstRow, this.interestsSecondRow);
  final String text;
  final List<String> interestsFirstRow;
  final List<String> interestsSecondRow;
}

const interestsList = [
  Interest(
    'News & Current Events',
    [
      'World News',
      'Politics',
      'Business & Finance',
      'Technology',
      'Science',
    ],
    [
      'Health',
      'Environment',
      'Education',
      'Law',
      'Crime',
    ],
  ),
  Interest(
    'Lifestyle',
    [
      'Fashion & Beauty',
      'Relationships',
      'Parenting',
      'Health & Fitness',
      'Food & Cooking',
    ],
    [
      'Travel',
      'Personal Finance',
      'Home & Garden',
      'Pets',
      'DIY & Crafts',
    ],
  ),
  Interest(
    'Entertainment',
    [
      'Movies',
      'TV Shows',
      'Music',
      'Books',
      'Comics & Manga',
    ],
    [
      'Anime',
      'Podcasts',
      'Theater',
      'Stand-up Comedy',
      'Celebrity News & Gossip',
    ],
  ),
  Interest(
    'Gaming',
    [
      'Video Games',
      'PC Gaming',
      'Console Gaming',
      'Mobile Gaming',
      'Esports',
    ],
    [
      'Gaming News',
      'Game Development',
      'Tabletop Games',
      'Board Games',
      'Card Games',
    ],
  ),
  Interest(
    'Sports',
    [
      'Football',
      'Basketball',
      'Baseball',
      'Soccer',
      'Hockey',
    ],
    [
      'Tennis',
      'Golf',
      'MMA',
      'Boxing',
      'Motorsports',
    ],
  ),
  Interest(
    'Hobbies & Interests',
    [
      'Photography',
      'Art & Design',
      'Music Production',
      'Writing & Poetry',
      'Coding & Programming',
    ],
    [
      'Learning Languages',
      'History',
      'Science Fiction & Fantasy',
      'Investing',
      'Collecting',
    ],
  ),
  Interest(
    'Science & Technology',
    [
      'Space',
      'Physics',
      'Chemistry',
      'Biology',
      'Mathematics',
    ],
    [
      'Engineering',
      'Artificial Intelligence',
      'Robotics',
      'Gadgets',
      'Virtual Reality',
    ],
  ),
  Interest(
    'Culture & Society',
    [
      'History',
      'Philosophy',
      'Psychology',
      'Sociology',
      'Religion',
    ],
    [
      'Mythology',
      'Languages',
      'Anthropology',
      'Archaeology',
      'Politics',
    ],
  ),
  Interest(
    'Humor & Memes',
    [
      'Memes',
      'Funny Videos',
      'Stand-up Comedy',
      'Satire',
      'Dark Humor',
    ],
    [
      'Wholesome Memes',
      'Reaction GIFs',
      'Fails & Win',
      'Animals & Pets',
      'Funny Videos',
    ],
  ),
];
