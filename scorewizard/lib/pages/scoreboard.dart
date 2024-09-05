// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scorewizard/services/firestore.dart';

class ScoreboardScreen extends StatefulWidget {
  const ScoreboardScreen();

  @override
  State<ScoreboardScreen> createState() => _ScoreboardScreenState();
}

class _ScoreboardScreenState extends State<ScoreboardScreen> {
  Map<String, String> teamLogos = {
    'DRivals': 'assets/images/drivals.png',
    'AFG': 'assets/images/AFG.png',
    'None': 'assets/images/gigachad.png',
  };
  String player1NameDisplay = '';
  String player2NameDisplay = '';
  String stageDisplay = '';
  String p1ScoreDisplay = '';
  String p2ScoreDisplay = '';

  String defaultTeamLogoPath = 'None';

  String? selectedTeam1 = 'None';
  String? selectedTeam2 = 'None';

  int player1Score = 0;
  int player2Score = 0;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    DocumentSnapshot matchData =
        await FirestoreService.getInitialData('match1');
    setState(() {
      player1NameController.text = matchData['player1Name'];
      player2NameController.text = matchData['player2Name'];
      player1Score = matchData['player1Score'];
      player2Score = matchData['player2Score'];
      selectedTeam1 = matchData['player1TeamLogo'];
      selectedTeam2 = matchData['player2TeamLogo'];
      stageController.text = matchData['stage'];
    });
  }

  final TextEditingController player1NameController = TextEditingController();
  final TextEditingController player2NameController = TextEditingController();
  final TextEditingController stageController = TextEditingController();

  Future<void> _saveData() async {
    String team1 = "";
    String team2 = "";

    team1 = selectedTeam1!;
    team2 = selectedTeam2!;

    String matchId =
        'match1'; // You can dynamically generate or retrieve matchId
    String player1Name = player1NameController.text;
    String player2Name = player2NameController.text;
    String stage = stageController.text;

    await FirestoreService.updateMatch(
      matchId: matchId,
      player1Name: player1Name,
      player2Name: player2Name,
      player1Score: player1Score,
      player2Score: player2Score,
      player1TeamLogo: team1,
      player2TeamLogo: team2,
      stage: stage,
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black, // Change the color as needed
    ));

    return Scaffold(
      backgroundColor: Color(0xFFDADADA),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirestoreService.getMatchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {}

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No matches found'));
          }

          return SafeArea(
            child: Column(
              children: [
                Container(
                  height: 210,
                  decoration: BoxDecoration(
                    color: Color(0xFFEEEEEE),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'STAGE',
                        style: TextStyle(
                            color: Color(0xFF2E2E2E),
                            fontSize: 12,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        stageDisplay.isEmpty
                            ? stageController.text.toUpperCase()
                            : stageDisplay.toUpperCase(),
                        style: TextStyle(
                            color: Color(0xFF2E2E2E),
                            fontSize: 18,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 12, left: 12, right: 12),
                        padding: EdgeInsets.all(8),
                        height: 110,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color.fromARGB(255, 46, 46, 46),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      margin: EdgeInsets.only(top: 4),
                                      child: Image.asset(
                                        teamLogos[selectedTeam1] ??
                                            'assets/images/gigachad.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: Center(
                                        child: Text(
                                          player1NameDisplay.isEmpty
                                              ? player1NameController.text
                                              : player1NameDisplay,
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Expanded(
                                      child: Transform.translate(
                                    offset: Offset(0, 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              p1ScoreDisplay.isEmpty
                                                  ? player1Score.toString()
                                                  : p1ScoreDisplay,
                                              style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                color: Colors.white,
                                                fontSize:
                                                    32, // Dynamic font size
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              ':',
                                              style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                color: Color(0xFF707070),
                                                fontSize:
                                                    24, // Dynamic font size
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              p2ScoreDisplay.isEmpty
                                                  ? player2Score.toString()
                                                  : p2ScoreDisplay,
                                              style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                color: Colors.white,
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                                  Expanded(
                                    child: Transform.translate(
                                      offset: Offset(0, -4),
                                      child: Stack(
                                        children: [
                                          Center(
                                            child: Container(
                                              width: 85,
                                              height: 12,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                color: Color(0xFFFF6A00),
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Transform.translate(
                                              offset: Offset(0, -1),
                                              child: Text(
                                                'Match Start',
                                                style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 8,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      margin: EdgeInsets.only(top: 4),
                                      child: Image.asset(
                                        teamLogos[selectedTeam2] ??
                                            'assets/images/gigachad.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: Center(
                                          child: Text(
                                              player2NameDisplay.isEmpty
                                                  ? player2NameController.text
                                                  : player2NameDisplay,
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12))),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        height: 88,
                        margin: EdgeInsets.only(left: 24, right: 24, top: 24),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xFFEEEEEE),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color(0xFFEEEEEE),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                margin:
                                                    EdgeInsets.only(bottom: 4),
                                                child: Text(
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    'STAGE'),
                                              )
                                            ],
                                          ),
                                          Container(
                                            height: 40,
                                            margin: EdgeInsets.only(top: 4),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            child: TextField(
                                              controller: stageController,
                                              onChanged: (value) {
                                                stageController.text = value;
                                                setState(() {
                                                  stageDisplay = value;
                                                });
                                              },
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.all(8),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    borderSide: BorderSide(
                                                        width: 0,
                                                        style:
                                                            BorderStyle.none)),
                                                filled: true,
                                                fillColor: Color(0xFFDADADA),
                                                hintText: 'Match Stage...',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(24),
                        height: 142,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                margin: EdgeInsets.only(right: 8),
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xFFEEEEEE),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(bottom: 4),
                                          child: Text(
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                              'Player 1 Data'),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 40,
                                            margin: EdgeInsets.only(top: 4),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            child: TextField(
                                              controller: player1NameController,
                                              onChanged: (value) {
                                                player1NameController.text =
                                                    value;
                                                setState(() {
                                                  player1NameDisplay = value;
                                                });
                                              },
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.all(8),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    borderSide: BorderSide(
                                                        width: 0,
                                                        style:
                                                            BorderStyle.none)),
                                                filled: true,
                                                fillColor: Color(0xFFDADADA),
                                                hintText: 'Player Name...',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 40,
                                            color: Color(0xFFDADADA),
                                            margin: EdgeInsets.only(top: 8),
                                            padding: EdgeInsets.only(left: 8),
                                            child: DropdownButton<String>(
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                              isExpanded: true,
                                              items: teamLogos.keys
                                                  .map((String teamName) {
                                                return DropdownMenuItem<String>(
                                                  value: teamName,
                                                  child: Text(teamName),
                                                );
                                              }).toList(),
                                              hint: Text('Team'),
                                              onChanged: (teamName) {
                                                setState(() {
                                                  selectedTeam1 = teamName;
                                                });
                                              },
                                              value: selectedTeam1,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 64,
                                          margin: EdgeInsets.only(bottom: 12),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Color(0xFFFF6A00),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              padding: EdgeInsets.zero,
                                            ),
                                            onPressed: () {
                                              player1Score++;
                                              setState(() {
                                                p1ScoreDisplay =
                                                    player1Score.toString();
                                              });
                                            },
                                            child: Center(
                                              child: Text(
                                                '+',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 64,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Color(0xFFFF6A00),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              padding: EdgeInsets.zero,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                if (player1Score > 0) {
                                                  player1Score--;
                                                }
                                                p1ScoreDisplay =
                                                    player1Score.toString();
                                              });
                                            },
                                            child: Center(
                                              child: Text(
                                                '-',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(left: 24, right: 24, bottom: 24),
                        height: 142,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                margin: EdgeInsets.only(right: 8),
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xFFEEEEEE),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(bottom: 4),
                                          child: Text(
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                              'Player 2 Data'),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 40,
                                            margin: EdgeInsets.only(top: 4),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            child: TextField(
                                              controller: player2NameController,
                                              onChanged: (value) {
                                                player2NameController.text =
                                                    value;
                                                setState(() {
                                                  player2NameDisplay = value;
                                                });
                                              },
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.all(8),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    borderSide: BorderSide(
                                                        width: 0,
                                                        style:
                                                            BorderStyle.none)),
                                                filled: true,
                                                fillColor: Color(0xFFDADADA),
                                                hintText: 'Player Name...',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 40,
                                            color: Color(0xFFDADADA),
                                            margin: EdgeInsets.only(top: 8),
                                            padding: EdgeInsets.only(left: 8),
                                            child: DropdownButton<String>(
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                              isExpanded: true,
                                              items: teamLogos.keys
                                                  .map((String teamName) {
                                                return DropdownMenuItem<String>(
                                                  value: teamName,
                                                  child: Text(teamName),
                                                );
                                              }).toList(),
                                              hint: Text('Team'),
                                              onChanged: (teamname) {
                                                setState(() {
                                                  selectedTeam2 = teamname;
                                                });
                                              },
                                              value: selectedTeam2,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 64,
                                          margin: EdgeInsets.only(bottom: 12),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Color(0xFFFF6A00),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              padding: EdgeInsets.zero,
                                            ),
                                            onPressed: () {
                                              player2Score++;
                                              setState(() {
                                                p2ScoreDisplay =
                                                    player2Score.toString();
                                              });
                                            },
                                            child: Center(
                                              child: Text(
                                                '+',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 64,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Color(0xFFFF6A00),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              padding: EdgeInsets.zero,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                if (player2Score > 0) {
                                                  player2Score--;
                                                }
                                                p2ScoreDisplay =
                                                    player2Score.toString();
                                              });
                                            },
                                            child: Center(
                                              child: Text(
                                                '-',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(left: 24, right: 24, bottom: 24),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFF6A00),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: _saveData,
                          child: Text(
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              'SAVE'),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
