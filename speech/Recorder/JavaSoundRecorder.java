import javax.sound.sampled.*;
import java.io.*;
public class JavaSoundRecorder 
{
	// record duration, in milliseconds
	//static final long RECORD_TIME =4000;	// 2 seconds
	static long RECORD_TIME =4000;	// 2 seconds

	// path of the wav file
	File wavFile = new File("/home/pi/speech/Recorder/input.wav");

	// format of audio file
	AudioFileFormat.Type fileType = AudioFileFormat.Type.WAVE;

	// the line from which audio data is captured
	TargetDataLine line;

	/**
	 * Defines an audio format
	 */
	AudioFormat getAudioFormat() {
		float sampleRate = 8000.0F;
		int sampleSizeInBits = 16;
		int channels = 1;
		boolean signed = true;
		boolean bigEndian = false;
		AudioFormat format = new AudioFormat(sampleRate, sampleSizeInBits,
											 channels, signed, bigEndian);
		return format;
	}

	/**
	 * Captures the sound and record into a WAV file
	 */
	void start() {
		try {
			AudioFormat format = getAudioFormat();
			DataLine.Info info = new DataLine.Info(TargetDataLine.class, format);

			// checks if system supports the data line
			if (!AudioSystem.isLineSupported(info)) {
				System.out.println("Line not supported");
				System.exit(0);
			}
			line = (TargetDataLine) AudioSystem.getLine(info);
			line.open(format);
			line.start();	// start capturing

			System.out.println("Start capturing...");

			AudioInputStream ais = new AudioInputStream(line);

			System.out.println("Start recording...");

			// start recording
			AudioSystem.write(ais, fileType, wavFile);

		} catch (LineUnavailableException ex) {
			ex.printStackTrace();
		} catch (IOException ioe) {
			ioe.printStackTrace();
		}
	}

	/**
	 * Closes the target data line to finish capturing and recording
	 */
	void finish() {
		line.stop();
		line.close();
		System.out.println("Finished");
	}

	/**
	 * Entry to run the program
	 */
public static void main(String[] args) 
{
		if(args.length>=1)
		{
			//System.out.println(args[0]);
			JavaSoundRecorder.RECORD_TIME =Long.parseLong(args[0]);
		}
		final JavaSoundRecorder recorder = new JavaSoundRecorder();

		// creates a new thread that waits for a specified
		// of time before stopping
		Thread stopper = new Thread(new Runnable() {
			public void run() {
				try {
					Thread.sleep(RECORD_TIME);
				} catch (InterruptedException ex) {
					ex.printStackTrace();
				}
                                //recorder stops after waiting for RECORD_TIME
				recorder.finish();
			}
		});			
		stopper.start();

		// start recording
		recorder.start();
	}
}
