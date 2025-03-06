import 'package:chatopia/l10n/generated/l10n.dart';
import 'package:chatopia/router/router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _textController = TextEditingController();

  // 定义会话记录数据结构
  final List<Map<String, dynamic>> _chatRecords = [
    {
      'title': '会话记录 1',
      'time': DateTime(2023, 10, 5),
      'content': '这是会话记录 1 的内容',
    },
    {
      'title': '会话记录 2',
      'time': DateTime(2023, 10, 6),
      'content': '这是会话记录 2 的内容',
    },
    {
      'title': '会话记录 3',
      'time': DateTime(2023, 10, 5),
      'content': '这是会话记录 3 的内容',
    },
    {
      'title': '会话记录 4',
      'time': DateTime(2025, 3, 6),
      'content': '这是会话记录 4 的内容',
    },
  ];

  // 定义聊天记录数据结构
  final List<Map<String, dynamic>> _chatMessages = [
    {
      'message': '你好！',
      'isMe': true,
      'time': DateTime(2024, 3, 6),
      'username': '我',
      'avatar': Icons.person, // 右侧气泡头像使用用户图标
      'tokens': 24,
      'tokensPerSecond': 12,
    },
    {
      'message': '你好，有什么可以帮助你的吗？',
      'isMe': false,
      'time': DateTime(2025, 3, 6),
      'username': '助手',
      'avatar': Icons.person, // 左侧气泡头像使用网络图片
      'tokens': 24,
      'tokensPerSecond': 12,
    },
    {
      'message': '我想了解更多关于这个应用的信息。',
      'isMe': true,
      'time': DateTime(2025, 3, 6),
      'username': '我',
      'avatar': Icons.person,
      'tokens': 24,
      'tokensPerSecond': 12,
    },
    {
      'message': '当然！这是一个聊天应用，支持多种功能。',
      'isMe': false,
      'time': DateTime.now(),
      'username': '助手',
      'avatar': Icons.person,
      'tokens': 234,
      'tokensPerSecond': 13,
    },
  ];

  // 按时间分组会话记录
  Map<String, List<Map<String, dynamic>>> _groupChatRecordsByDate() {
    final Map<String, List<Map<String, dynamic>>> groupedRecords = {};

    for (var record in _chatRecords) {
      final date = record['time'] as DateTime;
      final dateKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      if (!groupedRecords.containsKey(dateKey)) {
        groupedRecords[dateKey] = [];
      }
      groupedRecords[dateKey]!.add(record);
    }

    final sortedKeys =
        groupedRecords.keys.toList()..sort((a, b) => b.compareTo(a));

    final Map<String, List<Map<String, dynamic>>> sortedGroupedRecords = {};
    for (var key in sortedKeys) {
      sortedGroupedRecords[key] = groupedRecords[key]!;
    }

    return sortedGroupedRecords;
  }

  // 判断日期是否为今天
  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // 发送消息
  void _sendMessage() {
    final message = _textController.text.trim();
    if (message.isNotEmpty) {
      if (kDebugMode) {
        print('发送消息: $message');
      }
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final intl = S.of(context);
    String currentTopic = intl.newTopic;
    // 获取分组后的会话记录
    final groupedRecords = _groupChatRecordsByDate();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Center(child: Text(currentTopic)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(icon: const Icon(Icons.add), onPressed: () {}),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Center(
                child: Text(
                  'chatopia',
                  style: TextStyle(
                    fontFamily: 'Pacifico',
                    fontSize: 32,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ...groupedRecords.entries.map((entry) {
                    final date = DateTime.parse(entry.key);
                    final records = entry.value;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: Text(
                            _isToday(date)
                                ? intl.today
                                : DateFormat(intl.dateFormat).format(date),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                        ...records.map((record) {
                          return ListTile(
                            title: Text(
                              record['title'],
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            onTap: () {
                              // 处理会话记录点击事件
                            },
                          );
                        }),
                      ],
                    );
                  }),
                ],
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              title: Text(
                intl.settings,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              onTap: () => Navigator.pushNamed(context, AppRouter.settingsPage),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children:
            _chatMessages.map((message) {
              return _buildMessageBubble(
                message: message['message'] as String,
                isMe: message['isMe'] as bool,
                time: message['time'] as DateTime,
                username: message['username'] as String,
                avatar: message['avatar'],
                tokens: message['tokens'] as int,
                tokensPerSecond: message['tokensPerSecond'] as int,
              );
            }).toList(),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 48.0,
                  height: 48.0,
                  child: ElevatedButton(
                    onPressed: () {
                      if (kDebugMode) {
                        print('切换模型');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.zero,
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                    ),
                    child: Icon(
                      Icons.swap_horiz,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                SizedBox(
                  width: 48.0,
                  height: 48.0,
                  child: ElevatedButton(
                    onPressed: () {
                      if (kDebugMode) {
                        print('联网搜索');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.zero,
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                    ),
                    child: Icon(
                      Icons.public,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                SizedBox(
                  width: 48.0,
                  height: 48.0,
                  child: ElevatedButton(
                    onPressed: () {
                      if (kDebugMode) {
                        print('重置话题');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.zero,
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                    ),
                    child: Icon(
                      Icons.refresh,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                SizedBox(
                  width: 48.0,
                  height: 48.0,
                  child: ElevatedButton(
                    onPressed: () {
                      if (kDebugMode) {
                        print('话题设置');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.zero,
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                    ),
                    child: Icon(
                      Icons.edit,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                SizedBox(
                  width: 48.0,
                  height: 48.0,
                  child: ElevatedButton(
                    onPressed: () {
                      if (kDebugMode) {
                        print('分享');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.zero,
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                    ),
                    child: Icon(
                      Icons.share,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: '输入消息...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                // 新增的加号按钮
                SizedBox(
                  width: 48.0,
                  height: 48.0,
                  child: ElevatedButton(
                    onPressed: () {
                      if (kDebugMode) {
                        print('打开附加功能');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.zero,
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                    ),
                    child: Icon(
                      Icons.add,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                SizedBox(
                  width: 48.0,
                  height: 48.0,
                  child: ElevatedButton(
                    onPressed: _sendMessage,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.zero,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      splashFactory: InkRipple.splashFactory,
                    ),
                    child: Icon(
                      Icons.send,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 构建聊天气泡
  Widget _buildMessageBubble({
    required String message,
    required bool isMe,
    required DateTime time,
    required String username,
    required dynamic avatar,
    required int tokens,
    required int tokensPerSecond,
  }) {
    final intl = S.of(context);
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isMe)
                CircleAvatar(
                  backgroundImage:
                      avatar is String ? NetworkImage(avatar) : null,
                  child:
                      avatar is IconData
                          ? Icon(
                            avatar,
                            color: Theme.of(context).colorScheme.onPrimary,
                          )
                          : null,
                ),
              if (!isMe) const SizedBox(width: 8.0),
              if (!isMe)
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '$username · ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      TextSpan(
                        text:
                            _isToday(time)
                                ? "${intl.today} ${DateFormat(intl.timeFormat).format(time)}"
                                : "${DateFormat(intl.dateFormat).format(time)} ${DateFormat(intl.timeFormat).format(time)}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              if (isMe)
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text:
                            _isToday(time)
                                ? "${intl.today} ${DateFormat(intl.timeFormat).format(time)}"
                                : "${DateFormat(intl.dateFormat).format(time)} ${DateFormat(intl.timeFormat).format(time)}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      TextSpan(
                        text: ' · $username',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              if (isMe) const SizedBox(width: 8.0),
              if (isMe)
                CircleAvatar(
                  backgroundImage:
                      avatar is String ? NetworkImage(avatar) : null,
                  child:
                      avatar is IconData
                          ? Icon(
                            avatar,
                            color: Theme.of(context).colorScheme.onPrimary,
                          )
                          : null,
                ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: isMe ? 0 : 48.0,
            right: isMe ? 48.0 : 0,
          ),
          child: Ink(
            decoration: BoxDecoration(
              color:
                  isMe
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.only(
                topLeft: isMe ? const Radius.circular(12.0) : Radius.zero,
                topRight: isMe ? Radius.zero : const Radius.circular(12.0),
                bottomLeft: const Radius.circular(12.0),
                bottomRight: const Radius.circular(12.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: InkWell(
              onLongPress: () {
                if (kDebugMode) {
                  print('长按气泡: $message');
                }
              },
              borderRadius: BorderRadius.only(
                topLeft: isMe ? const Radius.circular(12.0) : Radius.zero,
                topRight: isMe ? Radius.zero : const Radius.circular(12.0),
                bottomLeft: const Radius.circular(12.0),
                bottomRight: const Radius.circular(12.0),
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 8.0,
                ),
                child: Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      style: TextStyle(
                        color:
                            isMe
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.onSurface,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$tokens tokens • $tokensPerSecond tokens/s',
                      style: TextStyle(
                        color:
                            isMe
                                ? Theme.of(
                                  context,
                                ).colorScheme.onPrimary.withOpacity(0.7)
                                : Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.7),
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
