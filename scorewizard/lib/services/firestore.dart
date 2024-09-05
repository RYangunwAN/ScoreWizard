import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static Stream<QuerySnapshot> getMatchData() {
    return FirebaseFirestore.instance.collection('matches').snapshots();
  }

  static Future<Map<String, dynamic>> getInitialScores() async {
    try {
      DocumentSnapshot matchSnapshot = await FirebaseFirestore.instance
          .collection('matches')
          .doc('match1')
          .get();
      if (matchSnapshot.exists) {
        return matchSnapshot.data() as Map<String, dynamic>;
      } else {
        return {};
      }
    } catch (e) {
      print('Error fetching initial scores: $e');
      return {};
    }
  }

  static Future<DocumentSnapshot> getInitialData(String matchId) async {
    try {
      DocumentSnapshot matchData = await FirebaseFirestore.instance
          .collection('matches')
          .doc(matchId)
          .get();
      return matchData;
    } catch (e) {
      print("Error getting match data: $e");
      rethrow;
    }
  }

  static Future<void> updateMatch({
    required String matchId,
    required String player1Name,
    required String player2Name,
    required int player1Score,
    required int player2Score,
    required String player1TeamLogo,
    required String player2TeamLogo,
    required String stage,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('matches')
          .doc('match1')
          .update({
        'player1Name': player1Name,
        'player2Name': player2Name,
        'player1Score': player1Score,
        'player2Score': player2Score,
        'player1TeamLogo': player1TeamLogo,
        'player2TeamLogo': player2TeamLogo,
        'stage': stage,
      });
      print('Match data updated successfully!');
    } catch (e) {
      print('Error updating match data: $e');
    }
  }
}
