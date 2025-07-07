import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF181818),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(32, 40, 32, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 26, width: 26, child: SvgPicture.asset('arrow-back.svg')),
                SizedBox(width: 24),
                Text("Notifications", style: GoogleFonts.inter(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700))
              ],
            ),
          ),

          SizedBox(height: 48),

          Expanded( // ← just this added
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(36, 0, 36, 36),
              child: Container(
                width: double.infinity,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Today", style: GoogleFonts.quicksand(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                        Text("Mark All As Read", style: GoogleFonts.quicksand(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600))
                      ],
                    ),

                    SizedBox(height: 24),

                    Container(
                      width: double.infinity,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 72,
                                width: 72,
                                decoration: BoxDecoration(
                                  color: Color(0xFF383838),
                                  borderRadius: BorderRadius.circular(100)
                                )
                              ),
                              SizedBox(width: 24),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(maxWidth: 300),
                                        child: Text("Lorem ipsum dolor sit amet, consectetur adipiscing  elit, sed do eiusmod tempor incididunt elit, sed do eiusmod tempor incididunt", style: GoogleFonts.quicksand(color: Color(0xFF888888), fontSize: 12, height: 1.45), textAlign: TextAlign.justify, maxLines: 3),
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 6,
                                            height: 6,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFE83E3E),
                                              borderRadius: BorderRadius.circular(100)
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Text("1 minute ago", style: GoogleFonts.quicksand(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700))
                                        ],
                                      )
                                    ],
                                  )
                                )
                              )
                            ],
                          ),

                          SizedBox(height: 32),

                          Row(
                            children: [
                              Container(
                                height: 72,
                                width: 72,
                                decoration: BoxDecoration(
                                  color: Color(0xFF383838),
                                  borderRadius: BorderRadius.circular(100)
                                )
                              ),
                              SizedBox(width: 24),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(maxWidth: 300),
                                        child: Text("Lorem ipsum dolor sit amet, consectetur adipiscing  elit, sed do eiusmod tempor incididunt elit, sed do eiusmod tempor incididunt", style: GoogleFonts.quicksand(color: Color(0xFF888888), fontSize: 12, height: 1.45), textAlign: TextAlign.justify, maxLines: 3),
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 6,
                                            height: 6,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFE83E3E),
                                              borderRadius: BorderRadius.circular(100)
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Text("1 minute ago", style: GoogleFonts.quicksand(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700))
                                        ],
                                      )
                                    ],
                                  )
                                )
                              )
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 32),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Yesterday", style: GoogleFonts.quicksand(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                      ],
                    ),

                    SizedBox(height: 24),

                    Container(
                      width: double.infinity,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 72,
                                width: 72,
                                decoration: BoxDecoration(
                                  color: Color(0xFF383838),
                                  borderRadius: BorderRadius.circular(100)
                                )
                              ),
                              SizedBox(width: 24),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(maxWidth: 300),
                                        child: Text("Lorem ipsum dolor sit amet, consectetur adipiscing  elit, sed do eiusmod tempor incididunt elit, sed do eiusmod tempor incididunt", style: GoogleFonts.quicksand(color: Color(0xFF888888), fontSize: 12, height: 1.45), textAlign: TextAlign.justify, maxLines: 3),
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 6,
                                            height: 6,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFE83E3E),
                                              borderRadius: BorderRadius.circular(100)
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Text("1 minute ago", style: GoogleFonts.quicksand(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700))
                                        ],
                                      )
                                    ],
                                  )
                                )
                              )
                            ],
                          ),

                          SizedBox(height: 32),

                          Row(
                            children: [
                              Container(
                                height: 72,
                                width: 72,
                                decoration: BoxDecoration(
                                  color: Color(0xFF383838),
                                  borderRadius: BorderRadius.circular(100)
                                )
                              ),
                              SizedBox(width: 24),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(maxWidth: 300),
                                        child: Text("Lorem ipsum dolor sit amet, consectetur adipiscing  elit, sed do eiusmod tempor incididunt elit, sed do eiusmod tempor incididunt", style: GoogleFonts.quicksand(color: Color(0xFF888888), fontSize: 12, height: 1.45), textAlign: TextAlign.justify, maxLines: 3),
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 6,
                                            height: 6,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFE83E3E),
                                              borderRadius: BorderRadius.circular(100)
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Text("1 minute ago", style: GoogleFonts.quicksand(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700))
                                        ],
                                      )
                                    ],
                                  )
                                )
                              )
                            ],
                          ),

                          SizedBox(height: 32),

                          Row(
                            children: [
                              Container(
                                height: 72,
                                width: 72,
                                decoration: BoxDecoration(
                                  color: Color(0xFF383838),
                                  borderRadius: BorderRadius.circular(100)
                                )
                              ),
                              SizedBox(width: 24),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(maxWidth: 300),
                                        child: Text("Lorem ipsum dolor sit amet, consectetur adipiscing  elit, sed do eiusmod tempor incididunt elit, sed do eiusmod tempor incididunt", style: GoogleFonts.quicksand(color: Color(0xFF888888), fontSize: 12, height: 1.45), textAlign: TextAlign.justify, maxLines: 3),
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 6,
                                            height: 6,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFE83E3E),
                                              borderRadius: BorderRadius.circular(100)
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Text("1 minute ago", style: GoogleFonts.quicksand(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700))
                                        ],
                                      )
                                    ],
                                  )
                                )
                              )
                            ],
                          ),

                          SizedBox(height: 32),

                          Row(
                            children: [
                              Container(
                                height: 72,
                                width: 72,
                                decoration: BoxDecoration(
                                  color: Color(0xFF383838),
                                  borderRadius: BorderRadius.circular(100)
                                )
                              ),
                              SizedBox(width: 24),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(maxWidth: 300),
                                        child: Text("Lorem ipsum dolor sit amet, consectetur adipiscing  elit, sed do eiusmod tempor incididunt elit, sed do eiusmod tempor incididunt", style: GoogleFonts.quicksand(color: Color(0xFF888888), fontSize: 12, height: 1.45), textAlign: TextAlign.justify, maxLines: 3),
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 6,
                                            height: 6,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFE83E3E),
                                              borderRadius: BorderRadius.circular(100)
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Text("1 minute ago", style: GoogleFonts.quicksand(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700))
                                        ],
                                      )
                                    ],
                                  )
                                )
                              )
                            ],
                          ),

                          SizedBox(height: 32),

                          Row(
                            children: [
                              Container(
                                height: 72,
                                width: 72,
                                decoration: BoxDecoration(
                                  color: Color(0xFF383838),
                                  borderRadius: BorderRadius.circular(100)
                                )
                              ),
                              SizedBox(width: 24),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(maxWidth: 300),
                                        child: Text("Lorem ipsum dolor sit amet, consectetur adipiscing  elit, sed do eiusmod tempor incididunt elit, sed do eiusmod tempor incididunt", style: GoogleFonts.quicksand(color: Color(0xFF888888), fontSize: 12, height: 1.45), textAlign: TextAlign.justify, maxLines: 3),
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 6,
                                            height: 6,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFE83E3E),
                                              borderRadius: BorderRadius.circular(100)
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Text("1 minute ago", style: GoogleFonts.quicksand(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700))
                                        ],
                                      )
                                    ],
                                  )
                                )
                              )
                            ],
                          ),

                          SizedBox(height: 32),

                          Row(
                            children: [
                              Container(
                                height: 72,
                                width: 72,
                                decoration: BoxDecoration(
                                  color: Color(0xFF383838),
                                  borderRadius: BorderRadius.circular(100)
                                )
                              ),
                              SizedBox(width: 24),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(maxWidth: 300),
                                        child: Text("Lorem ipsum dolor sit amet, consectetur adipiscing  elit, sed do eiusmod tempor incididunt elit, sed do eiusmod tempor incididunt", style: GoogleFonts.quicksand(color: Color(0xFF888888), fontSize: 12, height: 1.45), textAlign: TextAlign.justify, maxLines: 3),
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 6,
                                            height: 6,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFE83E3E),
                                              borderRadius: BorderRadius.circular(100)
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Text("1 minute ago", style: GoogleFonts.quicksand(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700))
                                        ],
                                      )
                                    ],
                                  )
                                )
                              )
                            ],
                          )


                        ],
                      ),
                    )
                  ],
                ),
              )
            ),
          )
        ],
      )
    );
  }
}
