import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:qurany_karim/model/error_result.dart';
import 'package:qurany_karim/model/surah.dart';
import 'package:qurany_karim/repositories/quran/repository.dart';
import 'package:qurany_karim/utils/constants/cache_keys.dart';

class QuranLocalService extends QuranRepository {
  @override
  Future<Either<List<Surah>, ErrorResult>> getQuranData() async {
    try {
      Box<Surah> box = await Hive.openBox<Surah>(quranResponse);
      List<Surah> quranData = box.values.toList();
      return Left(quranData);
    } catch (exception) {
      ErrorResult error = ErrorResult(
          errorMessage: 'local_exception'.tr(),
          errorImage: 'assets/icons/storage_error.png');
      return Right(error);
    }
  }

  Future<void> cachingQuranData({required List<Surah> data}) async {
    Box<Surah> box = await Hive.openBox<Surah>(quranResponse);
    for (Surah item in data) {
      box.add(item);
    }
    box.close();
  }

  Future<Either<Surah, ErrorResult>> getSurahData(int index) async {
    try {
      Box<Surah> box = await Hive.openBox<Surah>(quranResponse);
      Surah? cachedSurah = box.getAt(index - 1);
      return Left(cachedSurah!);
    } catch (exception) {
      ErrorResult error = ErrorResult(
          errorMessage: 'local_exception'.tr(),
          errorImage: 'assets/icons/storage_error.png');
      return Right(error);
    }
  }
}
