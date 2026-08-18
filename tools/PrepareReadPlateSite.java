import java.io.File;
import java.util.Arrays;

import net.imagej.updater.Checksummer;
import net.imagej.updater.FileObject;
import net.imagej.updater.FilesCollection;
import net.imagej.updater.FilesUploader;
import net.imagej.updater.util.StderrProgress;

/** Builds a complete ReadPlate update site using ImageJ's updater APIs. */
public class PrepareReadPlateSite {

    private static final String SITE_NAME = "ReadPlate";

    public static void main(final String[] args) throws Exception {
        if (args.length != 3) {
            throw new IllegalArgumentException(
                "Usage: PrepareReadPlateSite <staging-root> <output-directory> <public-site-url>");
        }

        final File stagingRoot = new File(args[0]).getCanonicalFile();
        final File outputDirectory = new File(args[1]).getCanonicalFile();
        final String siteUrl = args[2].endsWith("/") ? args[2] : args[2] + "/";

        final FilesCollection files = new FilesCollection(stagingRoot);
        // This builder operates on an isolated payload tree. Do not contact or
        // synchronize any core update site.
        files.removeUpdateSite(FilesCollection.DEFAULT_UPDATE_SITE);
        files.addUpdateSite(SITE_NAME, siteUrl, "file:",
            outputDirectory.getPath(), 0L);

        final String[] paths = {
            "plugins/ReadPlate_3.0.ijm",
            "plugins/ReadPlate/index.html",
            "plugins/ReadPlate/plate.jpg"
        };

        final StderrProgress progress = new StderrProgress();
        // Supplying an explicit path list is intentional: the generic updater
        // scanner does not automatically include .html or .jpg files under
        // plugins/, but an update-site database can install them normally.
        new Checksummer(files, progress).updateFromLocal(Arrays.asList(paths));

        setMetadata(files.get(paths[0]),
            "ReadPlate 3.0 measures intensity and absorbance from photographs " +
            "of 6-, 12-, 24-, 48-, and 96-well plates.");
        setMetadata(files.get(paths[1]),
            "Original ReadPlate 3.0 documentation.");
        setMetadata(files.get(paths[2]),
            "Original sample photograph of a 96-well plate.");

        for (final String path : paths) {
            files.get(path).setAction(files, FileObject.Action.UPLOAD);
        }

        final FilesUploader uploader =
            new FilesUploader(null, files, SITE_NAME, progress);
        if (!uploader.login()) {
            throw new IllegalStateException("Local updater output could not be opened");
        }
        try {
            uploader.upload(progress);
        }
        finally {
            uploader.logout();
        }
    }

    private static void setMetadata(final FileObject file,
        final String description)
    {
        if (file == null) {
            throw new IllegalStateException(
                "ImageJ Updater did not index a required ReadPlate payload");
        }
        file.updateSite = SITE_NAME;
        file.description = description;
        file.addAuthor("Jos� Mar�a Delfino");
        file.addLink("https://github.com/ghanerka/ReadPlate");
        file.addLink("https://doi.org/10.1002/bmb.21139");
        file.metadataChanged = true;
    }
}
