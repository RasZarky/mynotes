class DatabaseUser{
  final int id;
  final String email;
  const DatabaseUser({required this.id, required this.email});

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() => "Person, ID = $id, email = $email";

  @override bool operator == (covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => super.hashCode;

}

class DatabaseNotes{
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;
  DatabaseNotes({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSyncedWithCloud,});

  DatabaseNotes.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String,
        isSyncedWithCloud = map[isSyncedWithCloudColumn as int]
            == 1 ? true : false ;

  @override
  String toString() => "Note, ID = $id, userId = $userId,"
      " isSyncedWithCloud = $isSyncedWithCloud, text = $text";

  @override bool operator == (covariant DatabaseNotes other) => id == other.id;

  @override
  int get hashCode => super.hashCode;
}

const idColumn = "id";
const emailColumn = "email";
const userIdColumn = "user_id";
const textColumn = "text";
const isSyncedWithCloudColumn = "is_synced_with_cloud";