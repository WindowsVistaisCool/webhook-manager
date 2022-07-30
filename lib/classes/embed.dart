class Embed {
  Embed({
    this.title,
    this.description,
    this.url,
  }) {if (title == null && description == null) throw ArgumentError("Title and description cannot both be null!");}

  // TODO: Add support for valitation (character limits)
  String? title;
  String? description;
  String? url;

  Map<String, dynamic>? author;
  Map<String, dynamic>? footer;
  List<Map<String, dynamic>> fields = [];
  Map<String, dynamic>? image;
  Map<String, dynamic>? thumbnail;

  int color = 0;
  void setColor(int color) => this.color = color;

  void setAuthor(String name, {String? url, String? iconUrl}) => author = {"name": name, "url": url, "icon_url": iconUrl};
  void setFooter(String text, {String? iconUrl}) => footer = {"text": text, "icon_url": iconUrl};
  void addField(String name, String value, {bool inline = true}) => fields.add({'name': name, 'value': value, 'inline': inline});
  void setImage(String url, {int? width, int? height}) => image = {"url": url, "width": width, "height": height};
  void setThumbnail(String url, {int? width, int? height}) => thumbnail = {"url": url, "width": width, "height": height};

  String? messageAddon;
  void setMessageAddon(String messageAddon) => this.messageAddon = messageAddon;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (title != null) data['title'] = title;
    data['type'] = 'rich';
    if (description != null) data['description'] = description;
    if (url != null) data['url'] = url;
    data['color'] = color;
    if (footer != null) data['footer'] = footer;
    if (image != null) data['image'] = image;
    if (thumbnail != null) data['thumbnail'] = thumbnail;
    if (author != null) data['author'] = author;
    if (fields != []) data['fields'] = fields;
    if (messageAddon != null) data['content'] = messageAddon;
    return data;
  }
}