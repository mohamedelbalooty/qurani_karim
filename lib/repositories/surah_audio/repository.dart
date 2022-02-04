import 'package:dartz/dartz.dart';
import 'package:qurany_karim/model/error_result.dart';
import 'package:qurany_karim/model/surah_audio.dart';

abstract class SurahAudioRepository {
  Future<Either<List<AyahAudio>, ErrorResult>> getSurahAudio();
}
