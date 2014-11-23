import java.io.File;

import marf.MARF;
import marf.Storage.ModuleParams;
import marf.Storage.TrainingSet;
import marf.util.Debug;
import marf.util.MARFException;


/**
 * <p>Indentfies a speaker independently of text, based on the MARF framework.</p>
 *
 * <p>$Id: SpeakerIdentApp.java,v 1.42 2005/06/19 04:48:10 mokhov Exp $</p>
 *
 * @author The MARF Development Group.
 * @version 0.3.0
 * @since 0.0.1
 */
public class SpeakerIdentApp
{
	/*
	 * -----------------
	 * Apps. Versionning
	 * -----------------
	 */

	/**
	 * Current major version of the application.
	 */
	public static final int MAJOR_VERSION = 0;

	/**
	 * Current minor version of the application.
	 */
	public static final int MINOR_VERSION = 3;

	/**
	 * Current revision of the application.
	 */
	public static final int REVISION      = 0;

	/**
	 * Main body.
	 * @param argv command-line arguments
	 */
	public static void main(String[] argv)
	{
		SpeakersIdentDb oDB = new SpeakersIdentDb("speakers.txt");

		try
		{
			// Since some new API is always introduced...
			validateVersions();

			/*
			 * Database of speakers
			 */
			oDB.connect();
			oDB.query();

			/*
			 * If supplied in the command line,
			 * the system when classifying will output next
			 * to the guessed one
			 */
			int iExpectedID = -1;

			/*
			 * Default MARF setup
			 */

			MARF.setPreprocessingMethod(MARF.DUMMY);
			MARF.setFeatureExtractionMethod(MARF.FFT);
			MARF.setClassificationMethod(MARF.EUCLIDEAN_DISTANCE);
			MARF.setDumpSpectrogram(false);
			MARF.setSampleFormat(MARF.WAV);

			Debug.enableDebug(false);

			// Parse extra arguments
			// XXX: maybe it's time to move it to a sep. method
			for(int i = 2; i < argv.length; i++)
			{
				try
				{
					// Preprocessing

					if(argv[i].equals("-norm"))
						MARF.setPreprocessingMethod(MARF.DUMMY);

					else if(argv[i].equals("-boost"))
						MARF.setPreprocessingMethod(MARF.HIGH_FREQUENCY_BOOST_FFT_FILTER);

					else if(argv[i].equals("-high"))
						MARF.setPreprocessingMethod(MARF.HIGH_PASS_FFT_FILTER);

					else if(argv[i].equals("-low"))
						MARF.setPreprocessingMethod(MARF.LOW_PASS_FFT_FILTER);

					else if(argv[i].equals("-band"))
						MARF.setPreprocessingMethod(MARF.BANDPASS_FFT_FILTER);

					else if(argv[i].equals("-highpassboost"))
						MARF.setPreprocessingMethod(MARF.HIGH_PASS_BOOST_FILTER);

					else if(argv[i].equals("-raw"))
						MARF.setPreprocessingMethod(MARF.RAW);

					// Feature Extraction

					else if(argv[i].equals("-fft"))
						MARF.setFeatureExtractionMethod(MARF.FFT);

					else if(argv[i].equals("-lpc"))
						MARF.setFeatureExtractionMethod(MARF.LPC);

					else if(argv[i].equals("-randfe"))
						MARF.setFeatureExtractionMethod(MARF.RANDOM_FEATURE_EXTRACTION);

					else if(argv[i].equals("-minmax"))
						MARF.setFeatureExtractionMethod(MARF.MIN_MAX_AMPLITUDES);

					// Classification

					else if(argv[i].equals("-nn"))
					{
						MARF.setClassificationMethod(MARF.NEURAL_NETWORK);

						ModuleParams oParams = new ModuleParams();

						// Dump/Restore Format of the TrainingSet
						oParams.addClassificationParam(new Integer(TrainingSet.DUMP_GZIP_BINARY));

						// Training Constant
						oParams.addClassificationParam(new Double(1.0));

						// Epoch number
						oParams.addClassificationParam(new Integer(10));

						// Min. error
						oParams.addClassificationParam(new Double(4.27));

						MARF.setModuleParams(oParams);
					}

					else if(argv[i].equals("-eucl"))
						MARF.setClassificationMethod(MARF.EUCLIDEAN_DISTANCE);

					else if(argv[i].equals("-cheb"))
						MARF.setClassificationMethod(MARF.CHEBYSHEV_DISTANCE);

					else if(argv[i].equals("-mink"))
					{
						MARF.setClassificationMethod(MARF.MINKOWSKI_DISTANCE);

						ModuleParams oParams = new ModuleParams();

						// Dump/Restore Format
						oParams.addClassificationParam(new Integer(TrainingSet.DUMP_GZIP_BINARY));

						// Minkowski Factor
						oParams.addClassificationParam(new Double(6.0));

						MARF.setModuleParams(oParams);
					}

					else if(argv[i].equals("-mah"))
						MARF.setClassificationMethod(MARF.MAHALANOBIS_DISTANCE);

					else if(argv[i].equals("-randcl"))
						MARF.setClassificationMethod(MARF.RANDOM_CLASSIFICATION);

					else if(argv[i].equals("-diff"))
						MARF.setClassificationMethod(MARF.DIFF_DISTANCE);

					// Misc

					else if(argv[i].equals("-spectrogram"))
						MARF.setDumpSpectrogram(true);

					else if(argv[i].equals("-debug"))
						Debug.enableDebug(true);

					else if(argv[i].equals("-graph"))
						MARF.setDumpWaveGraph(true);

					else if(Integer.parseInt(argv[i]) > 0)
						iExpectedID = Integer.parseInt(argv[i]);
				}
				catch(NumberFormatException e)
				{
					// Number format exception should be ignored
					// XXX [SM]: Why?

					Debug.debug("SpeakerIdentApp.main() - NumberFormatException: " + e.getMessage());
				}
			} // extra args

			
			/*
			 * --------------
			 * Identification
			 * --------------
			 */
			if(argv[0].equals("--ident"))
			{
				/*
				 * If no expected speaker present on the command line,
				 * attempt to fetch it from the database by filename.
				 */
				if(iExpectedID < 0)
					iExpectedID = oDB.getIDByFilename(argv[1], false);

				// Store config and error/sucesses for that config
				String strConfig = "";

				if(argv.length > 2)
					// Get config from the command line
					for(int i = 2; i < argv.length; i++)
						strConfig += argv[i] + " ";

				else
					// Query MARF for it's current config
					strConfig = MARF.getConfig();

				MARF.setSampleFile(argv[1]);
				MARF.recognize();

				int iIdentifiedID = MARF.queryResultID();

				// Second best
				int iSecondClosestID = MARF.getResultSet().getSecondClosestID();

				//System.out.println("               Config: " + strConfig);
				System.out.println("USERID :"+iIdentifiedID);
				System.out.println("NAME :"+oDB.getName(iIdentifiedID));				
				//System.out.println("   	 Percentage match: " +MARF.getResult().getOutcome());
				/*
				 * Only collect stats if we have expected speaker
				 */
				if(iExpectedID > 0)
				{
					System.out.println("Expected Speaker's ID: " + iExpectedID);
					System.out.println("     Expected Speaker: " + oDB.getName(iExpectedID));
					System.out.println("       Second Best ID: " + iSecondClosestID);
					System.out.println("     Second Best Name: " + oDB.getName(iSecondClosestID));

					oDB.restore();
					{
						// 1st match
						oDB.addStats(strConfig, (iIdentifiedID == iExpectedID));

						// 2nd best: must be true if either 1st true or second true (or both :))
						boolean bSecondBest =
							iIdentifiedID == iExpectedID
							||
							iSecondClosestID == iExpectedID;

						oDB.addStats(strConfig, bSecondBest, true);
					}
					oDB.dump();
				}
				else
				{
//					System.out.println("       Second Best ID: " + iSecondClosestID);
//					System.out.println("     Second Best Name: " + oDB.getName(iSecondClosestID));
					System.out.println("\n");
				}
			}

			/*
			 * Training
			 */
			else if(argv[0].compareTo("--train") == 0)
			{
				try
				{
					System.out.println("\nIn train Module...stage1");
					// Dir contents
					File[] aFiles = new File(argv[1]).listFiles();

					String strFileName;

					// XXX: this loop has to be in MARF
					for(int i = 0; i < aFiles.length; i++)
					{
						strFileName = aFiles[i].getPath();

						if(strFileName.toLowerCase().endsWith(".wav"))
						{
							MARF.setSampleFile(strFileName);

							int iID = oDB.getIDByFilename(strFileName, true);

							if(iID == -1)
								System.out.println("No speaker found for \"" + strFileName + "\" for training.");
							else
							{
								MARF.setCurrentSubject(iID);
								MARF.train();
							}
						}
					}
					System.out.println("\nAfter Training...");
				}
				catch(NullPointerException e)
				{
					System.err.println("Folder \"" + argv[1] + "\" not found.");
					System.exit(-1);
				}

				System.out.println("Done training on folder \"" + argv[1] + "\".");
			}

			/*
			 * Stats
			 */
			else if(argv[0].equals("--stats"))
			{
				oDB.restore();
				oDB.printStats();
			}

			/*
			 * Best Result with Stats
			 */
			else if(argv[0].equals("--best-score"))
			{
				oDB.restore();
				oDB.printStats(true);
			}

			/*
			 * Reset Stats
			 */
			else if(argv[0].equals("--reset"))
			{
				oDB.resetStats();
				System.out.println("SpeakerIdentApp: Statistics has been reset.");
			}

			/*
			 * Versionning
			 */
			else if(argv[0].equals("--version"))
			{
				System.out.println("Text-Independent Speaker Identification Application, v." + getVersion());
				System.out.println("Using MARF, v." + MARF.getVersion());

				validateVersions();
			}

			/*
			 * Help
			 */
			else if(argv[0].equals("--help") || argv[0].equals("-h"))
			{
				usage();
			}

			/*
			 * Invalid major option
			 */
			else
				throw new Exception("Unrecognized option: " + argv[0]);
		}

		/*
		 * No arguments have been specified
		 */
		catch(ArrayIndexOutOfBoundsException e)
		{
			usage();
		}

		/*
		 * MARF-specific errors
		 */
		catch(MARFException e)
		{
			System.err.println(e.getMessage());
			e.printStackTrace(System.err);
		}

		/*
		 * Invalid option and/or option argument
		 */
		catch(Exception e)
		{
			System.err.println(e.getMessage());
			e.printStackTrace(System.err);
			usage();
		}

		/*
		 * Regardless whatever happens, close the db connection.
		 */
		finally
		{
			try
			{
				Debug.debug("Closing DB connection...");
				oDB.close();
			}
			catch(Exception e)
			{
				Debug.debug("Closing DB connection failed: " + e.getMessage());
				e.printStackTrace(System.err);
				System.exit(-1);
			}
		}
	}

	/**
	 * Displays application's usage information and exits.
	 */
	private static final void usage()
	{
		System.out.println
		(
			"Usage:\n" +
			"    java SpeakerIdentApp --train <samples-dir> [options]  -- train mode\n" +
			"                         --ident <sample> [options]       -- identification mode\n" +
			"                         --stats                          -- display stats\n" +
			"                         --reset                          -- reset stats\n" +
			"                         --version                        -- display version info\n" +
			"                         --help | -h                      -- display this help and exit\n\n" +

			"Options (one or more of the following):\n\n" +

			"Preprocessing:\n\n" +
			"  -raw          - no preprocessing\n" +
			"  -norm         - use just normalization, no filtering\n" +
			"  -low          - use low-pass filter\n" +
			"  -high         - use high-pass filter\n" +
			"  -boost        - use high-frequency-boost preprocessor\n" +
			"  -band         - use band-pass filter\n" +
			"\n" +

			"Feature Extraction:\n\n" +
			"  -lpc          - use LPC\n" +
			"  -fft          - use FFT\n" +
			"  -minmax       - use Min/Max Amplitudes\n" +
			"  -randfe       - use random feature extraction\n" +
			"\n" +

			"Classification:\n\n" +
			"  -nn           - use Neural Network\n" +
			"  -cheb         - use Chebyshev Distance\n" +
			"  -eucl         - use Euclidean Distance\n" +
			"  -mink         - use Minkowski Distance\n" +
			"  -diff         - use Diff-Distance\n" +
			"  -randcl       - use random classification\n" +
			"\n" +

			"Misc:\n\n" +
			"  -debug        - include verbose debug output\n" +
			"  -spectrogram  - dump spectrogram image after feature extraction\n" +
			"  -graph        - dump wave graph before preprocessing and after feature extraction\n" +
			"  <integer>     - expected speaker ID\n" +
			"\n"
		);

		System.exit(0);
	}

	/**
	 * Retrieves String representation of the application's version.
	 * @return version String
	 */
	public static final String getVersion()
	{
		return MAJOR_VERSION + "." + MINOR_VERSION + "." + REVISION;
	}

	/**
	 * Retrieves integer representation of the application's version.
	 * @return integer version
	 */
	public static final int getIntVersion()
	{
		return MAJOR_VERSION * 100 + MINOR_VERSION * 10 + REVISION;
	}

	/**
	 * Makes sure the applications isn't run against older MARF version.
	 * Exits with 1 if the MARF version is too old.
	 */
	public static final void validateVersions()
	{
		if(MARF.getIntVersion() < (0 * 100 + 3 * 10 + 0))
		{
			System.err.println
			(
				"Your MARF version (" + MARF.getVersion() +
				") is too old. This application requires 0.3.0 or above."
			);

			System.exit(1);
		}
	}
}

// EOF
