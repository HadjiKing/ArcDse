import 'package:arcdse/utils/imgs.dart';
import 'package:arcdse/utils/logger.dart';
import 'package:fluent_ui/fluent_ui.dart';

/// A grid of images for an appointment, with optional delete and drawing save.
class GridGallery extends StatelessWidget {
  final bool canDelete;
  final String rowId;
  final List<String> imgs;
  final bool progress;
  final Map<String, dynamic> drawings;
  final void Function(String img, dynamic drawing)? onSaveDrawing;
  final void Function(String imgName)? onDelete;

  const GridGallery({
    super.key,
    required this.canDelete,
    required this.rowId,
    required this.imgs,
    required this.progress,
    required this.drawings,
    this.onSaveDrawing,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (imgs.isEmpty) {
      return const Center(child: Icon(FluentIcons.photo2, size: 64));
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 120,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: imgs.length,
      itemBuilder: (context, i) {
        final img = imgs[i];
        return Stack(
          fit: StackFit.expand,
          children: [
            FutureBuilder<String?>(
              future: Future.value(getImgUrl(rowId, img)),
              builder: (context, snap) {
                if (!snap.hasData || snap.data == null) {
                  return const Center(child: ProgressRing());
                }
                return Image.network(snap.data!, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                  return const Icon(FluentIcons.photo2);
                });
              },
            ),
            if (canDelete)
              Positioned(
                top: 2,
                right: 2,
                child: IconButton(
                  icon: const Icon(FluentIcons.delete, size: 14),
                  onPressed: () async {
                    try {
                      await deleteImg(rowId, img);
                      onDelete?.call(img);
                    } catch (e, s) {
                      logger('Error deleting image: $e', s);
                    }
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
