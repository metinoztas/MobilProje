// lib/metin/ai/ai_sohbet.dart

import 'package:flutter/material.dart';
import '../model/sabitler.dart';
import 'ai_servis.dart';

class AiSohbet extends StatefulWidget {
  const AiSohbet({super.key});

  @override
  State<AiSohbet> createState() => _AiSohbetState();
}

class _AiSohbetState extends State<AiSohbet> {

  final TextEditingController mesajCtrl =
      TextEditingController();

  List<Map<String, String>> mesajlar = [];

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: const BoxDecoration(
        color: kCard,
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),

      padding:
          const EdgeInsets.fromLTRB(
        20,
        16,
        20,
        0,
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          // Başlık
          Row(
            mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,

            children: [

              const Row(
                children: [

                  Icon(
                    Icons.auto_awesome,
                    color: kPurple2,
                    size: 18,
                  ),

                  SizedBox(width: 6),

                  Text(
                    kAiBaslik,

                    style: TextStyle(
                      color: kText,
                      fontSize: 15,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),

              // Yeni sohbet
              GestureDetector(

                onTap: () {

                  setState(() {

                    mesajlar.clear();
                  });
                },

                child: Container(
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),

                  decoration:
                      BoxDecoration(
                    color: kPurple
                        .withOpacity(0.15),

                    borderRadius:
                        BorderRadius
                            .circular(16),

                    border: Border.all(
                      color: kPurple
                          .withOpacity(
                              0.3),
                    ),
                  ),

                  child: const Row(
                    children: [

                      Icon(
                        Icons
                            .chat_bubble_outline,
                        color: kPurple2,
                        size: 13,
                      ),

                      SizedBox(width: 4),

                      Text(
                        kYeniSohbet,

                        style: TextStyle(
                          color:
                              kPurple2,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          const Text(
            kAiAltBaslik,

            style: TextStyle(
              color: kGrey,
              fontSize: 11,
            ),
          ),

          const SizedBox(height: 12),

          // Mesajlar
          Expanded(
            child: ListView.builder(

              itemCount:
                  mesajlar.length,

              itemBuilder:
                  (context, index) {

                final mesaj =
                    mesajlar[index];

                final kullaniciMi =
                    mesaj["rol"] ==
                        "user";

                return Align(
                  alignment:
                      kullaniciMi
                          ? Alignment
                              .centerRight
                          : Alignment
                              .centerLeft,

                  child: Container(
                    margin:
                        const EdgeInsets
                            .symmetric(
                      vertical: 4,
                    ),

                    padding:
                        const EdgeInsets
                            .all(12),

                    decoration:
                        BoxDecoration(
                      color:
                          kullaniciMi
                              ? kPurple
                              : kBg,

                      borderRadius:
                          BorderRadius
                              .circular(
                                  14),
                    ),

                    child: Text(
                      mesaj["text"]!,

                      style:
                          const TextStyle(
                        color:
                            Colors
                                .white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Input alanı
          Row(
            children: [

              Expanded(
                child: TextField(
                  controller:
                      mesajCtrl,

                  style:
                      const TextStyle(
                    color: kText,
                  ),

                  decoration:
                      InputDecoration(
                    hintText:
                        "Mesaj yaz...",

                    hintStyle:
                        const TextStyle(
                      color: kGrey,
                    ),

                    filled: true,
                    fillColor: kBg,

                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                                  14),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              IconButton(

                onPressed:
                    () async {

                  final mesaj =
                      mesajCtrl.text
                          .trim();

                  if (mesaj
                      .isEmpty) {
                    return;
                  }

                  setState(() {

                    mesajlar.add({
                      "rol": "user",
                      "text": mesaj,
                    });
                  });

                  mesajCtrl.clear();

                  final cevap =
                      await AiServis
                          .mesajGonder(
                              mesaj);

                  setState(() {

                    mesajlar.add({
                      "rol": "ai",
                      "text": cevap,
                    });
                  });
                },

                icon: const Icon(
                  Icons.send,
                  color: kPurple2,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}