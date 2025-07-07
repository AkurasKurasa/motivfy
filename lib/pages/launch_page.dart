import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LaunchPage extends StatefulWidget {
  const LaunchPage({super.key});

  @override
  State<LaunchPage> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          Container( 
            margin: EdgeInsets.fromLTRB(32, 56, 32, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(width: 4),
                    Text("Hello, John!", style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16, letterSpacing: -0.1) ),
                    SizedBox(width: 16),
                    SizedBox(height: 24, width: 24, child: SvgPicture.asset('envelope.svg') )
                  ],
                ),
                SizedBox( height: 32, width: 32, child: SvgPicture.asset('assets/double-arrow.svg') )
              ],
            ),
          ),

          SizedBox(height: 24),

          Opacity(
            opacity: 0.5,
            child: Container(
              margin: EdgeInsets.fromLTRB(32, 0, 32, 0),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Color(0x73FFFFFF), Color(0x00FFFFFF)], stops: [0, 1.0], begin: Alignment(1, -1), end: Alignment(-1, 1) ),
                borderRadius: BorderRadius.circular(16)
              ), 
              width: double.infinity,
              height: 175
            )
          ),

          SizedBox(height: 56),

          Container(
            margin: EdgeInsets.fromLTRB(32, 0, 32, 0),
            decoration: BoxDecoration(
              // border: Border.all(
              //   color: Colors.white
              // )
            ), 
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Row(
                  children: [
                    Text("Discover", style: GoogleFonts.quicksand(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 32))
                  ],
                ),

                SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 8.0,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.5,
                          color: Color(0xFF505050)
                        ),
                        borderRadius: BorderRadius.circular(9)
                      ),
                      width: 125,
                      height: 125,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 32, width: 32, child: SvgPicture.asset('timer.svg') ),
                          SizedBox(height: 8),
                          Text('Pomodoro\nTimer', style: GoogleFonts.quicksand(color: Color(0xFF878787), fontWeight: FontWeight.w400, height: 1.0), textAlign: TextAlign.center)
                        ],
                      ),
                    ),

                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.5,
                          color: Color(0xFF505050)
                        ),
                        borderRadius: BorderRadius.circular(9)
                      ),
                      width: 125,
                      height: 125,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 40, width: 40, child: SvgPicture.asset('analyze.svg') ),
                          SizedBox(height: 8),
                          Text('Procrastination\nAnalysis', style: GoogleFonts.quicksand(color: Color(0xFF878787), fontWeight: FontWeight.w400, height: 1.0), textAlign: TextAlign.center)
                        ],
                      ),
                    ),

                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.5,
                          color: Color(0xFF505050)
                        ),
                        borderRadius: BorderRadius.circular(9)
                      ),
                      width: 125,
                      height: 125,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 40, width: 40, child: SvgPicture.asset('block.svg') ),
                          SizedBox(height: 8),
                          Text('Block\nList', style: GoogleFonts.quicksand(color: Color(0xFF878787), fontWeight: FontWeight.w400, height: 1.0), textAlign: TextAlign.center)
                        ],
                      ),
                    )
                  ],
                ),

                SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 8.0,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.5,
                          color: Color(0xFF505050)
                        ),
                        borderRadius: BorderRadius.circular(9)
                      ),
                      width: 125,
                      height: 125,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 32, width: 32, child: SvgPicture.asset('timer.svg') ),
                          SizedBox(height: 8),
                          Text('Done\nList', style: GoogleFonts.quicksand(color: Color(0xFF878787), fontWeight: FontWeight.w400, height: 1.0), textAlign: TextAlign.center)
                        ],
                      ),
                    ),

                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.5,
                          color: Color(0xFF505050)
                        ),
                        borderRadius: BorderRadius.circular(9)
                      ),
                      width: 125,
                      height: 125,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 40, width: 40, child: SvgPicture.asset('analyze.svg') ),
                          SizedBox(height: 8),
                          Text('Note\nFlow', style: GoogleFonts.quicksand(color: Color(0xFF878787), fontWeight: FontWeight.w400, height: 1.0), textAlign: TextAlign.center)
                        ],
                      ),
                    ),

                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.5,
                          color: Color(0xFF505050)
                        ),
                        borderRadius: BorderRadius.circular(9)
                      ),
                      width: 125,
                      height: 125,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 40, width: 40, child: SvgPicture.asset('block.svg') ),
                          SizedBox(height: 8),
                          Text('Productivity\nAssistant', style: GoogleFonts.quicksand(color: Color(0xFF878787), fontWeight: FontWeight.w400, height: 1.0), textAlign: TextAlign.center)
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
      backgroundColor: Color(0xFF181818),
    );
  }

}