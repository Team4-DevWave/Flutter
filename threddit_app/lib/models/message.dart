class Message {
  final String id;
  final String sender;
  final String recipient;
  final String? text;
  final String? imageUrl;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.sender,
    required this.recipient,
    this.text,
    this.imageUrl,
    required this.timestamp,
  });

  Message copyWith({
    String? id,
    String? sender,
    String? recipient,
    String? text,
    String? imageUrl,
    DateTime? timestamp,
  }) {
    return Message(
      id: id ?? this.id,
      sender: sender ?? this.sender,
      recipient: recipient ?? this.recipient,
      text: text ?? this.text,
      imageUrl: imageUrl ?? this.imageUrl,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sender': sender,
      'recipient': recipient,
      'text': text,
      'imageUrl': imageUrl,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] ?? '',
      sender: map['sender'] ?? '',
      recipient: map['recipient'] ?? '',
      text: map['text'],
      imageUrl: map['imageUrl'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
    );
  }

  @override
  String toString() {
    return 'Message(id: $id, sender: $sender, recipient: $recipient, text: $text, imageUrl: $imageUrl, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Message &&
        other.id == id &&
        other.sender == sender &&
        other.recipient == recipient &&
        other.text == text &&
        other.imageUrl == imageUrl &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        sender.hashCode ^
        recipient.hashCode ^
        text.hashCode ^
        imageUrl.hashCode ^
        timestamp.hashCode;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender,
      'recipient': recipient,
      'text': text,
      'imageUrl': imageUrl,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Factory method to create a Message object from a JSON map
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      sender: json['sender'],
      recipient: json['recipient'],
      text: json['text'],
      imageUrl: json['imageUrl'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
