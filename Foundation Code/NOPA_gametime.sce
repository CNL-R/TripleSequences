#header
default_background_color = 64, 64, 64;
write_codes = true;
pulse_width = 5;
active_buttons = 2;
button_codes = 254,255;
no_logfile = false;
###############################################################################
#SDL portion of code
begin;
$image_on = 300;
bitmap { filename = ""; preload = false; } bmp_image;
bitmap { filename = "flat.bmp"; preload = true; } flat_image;
wavefile {filename = ""; preload = false;} wav_sound;
text { caption = "+"; font_size = 10; font_color = 255,255,0; transparent_color = 64,64,64;
} fixcross;
text { caption = " "; font_size = 10; font_color = 64,64,64; transparent_color = 64,64,64;
} nada;
text { caption = "This is the Target Stimulus!! \n Study it and press the '1' button when ready to continue"; font_size = 32; font_color = 200,0,20; transparent_color = 64,64,64;
} traintxt;
text { caption = "Press the '3' button to repeat the stimulus (as many times as you wish)"; font_size = 20; font_color = 255,255,255; transparent_color = 64,64,64;
} repeattxt;
text { caption = "Take a short break, press the '1' button when you are ready to proceed"; font_size = 20; font_color = 0,220,200;
} breaktxt;
text { caption = "a"; font_size = 20; font_color = 0,220,205;
} counttxt1;
picture { text fixcross; x = 0; y = 0; text nada; x = 0; y = 320; text nada; x = 0; y = 420;
} default;
picture {bitmap bmp_image; x = 0; y = 0;} trial_pic;
picture {text repeattxt; x = 0; y = 320; text traintxt; x = 0; y = 420; text fixcross; x = 0; y = 0;} repeat_pic;
picture {bitmap bmp_image; x = 0; y = 0; text repeattxt; x = 0; y = 320; text traintxt; x = 0; y = 420;} odd_pic;
picture { text breaktxt; x = 0; y = 0; text counttxt1; x = 0; y = -200;} break_pic;
sound {wavefile wav_sound;} trial_aud;
trial { nothing{}; time = 0; port_code = 252;} pause_off;
trial { nothing{}; time = 0; port_code = 253;} pause_on;
trial {
	picture default;
	time = 0;
	stimulus_event {
		picture trial_pic;				# REMEMBER: ONSET TIMES HAVE NOT BEEN DEFINED
		duration = $image_on;
	} av_vis_evt;
	stimulus_event {
		sound trial_aud;
		port_code = 222; 					
		code = "StimOn";
		parallel = true;
	}av_aud_evt;
	stimulus_event {nothing{}; time = 60; port_code = 222;
	}code2;
	stimulus_event {nothing{};	time = 120; port_code = 222;
	}code3;
	stimulus_event {nothing{};	time = 180; port_code = 222;
	}code4;
} av_trl;
trial {
	picture default;
	time = 0;
	stimulus_event {
		picture odd_pic;
		duration = $image_on;			# REMEMBER: ONSET TIMES HAVE NOT BEEN DEFINED
	} odd_vis_evt;
	stimulus_event {
		sound trial_aud;
		parallel = true;
	}odd_aud_evt;
} oddball_train;
trial {										# Instructions that last til button press
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 1,2;
	stimulus_event {
		picture repeat_pic;
	} train_vis_event;
} repeat_train; 
trial {
	trial_duration = forever;
	trial_type = correct_response;
	stimulus_event {
		picture break_pic;
		target_button = 2;
	} break_event;
} break_time;
###############################################################################
begin_pcl;
int nblocks = 15;
int startingblock = 1;#It could be problematic if there were a crash mid-experiment, this allows you to start at a block other than 1
####################################
string filebase = "Block";			  # Root string of text files containing stimulus file names
####################################
#########################
# Some timing stuff to make the stims oh so perfectly synchronized
double period = display_device.refresh_period();
double max_scheduling_delay = 15;
double display_device_latency = 5;
double sound_card_latency = 10;
double additional_delay = 10; 		#play with this value to dial in the timing
int refresh_period_time = int(max_scheduling_delay / period) + 1;
double expected_picture_time = refresh_period_time * period;
int visoffset = int( expected_picture_time - period / 2 );
int audoffset = int( expected_picture_time + display_device_latency + additional_delay - sound_card_latency + 0.5);
av_vis_evt.set_time(visoffset);
odd_vis_evt.set_time(visoffset);
av_aud_evt.set_time(audoffset);
odd_aud_evt.set_time(audoffset);
###########################
string filename;
int isi;
loop
	int i = startingblock;
until i > nblocks begin
	filename = filebase + string(i) + ".txt";# Load in stimulus file names from text file
	array <string> stims[0];				#Create array for all stims listed in file
	input_file stimsf = new input_file; #Create input_file object
	stimsf.open(filename);					#Open file defined at top into input_file object
	loop
		string sname = stimsf.get_line();#Read the contents of the file into the stims array
	until !stimsf.last_succeeded() begin
		stims.add(sname);
		sname = stimsf.get_line();
	end;
	stimsf.close();							#Close the file
	int nstims = stims.count();			#number of stimuli to be presented per block
	loop
		int j = 1;
		array<string> stim_temp[0];
	until j > stims.count() begin
		stims[j].split( " ", stim_temp);
		if j == 1 then
			if int(stim_temp[1]) == 0 then
				odd_pic.set_part(1, bmp_image);
				bmp_image.set_filename(stim_temp[2]);
				bmp_image.load();
				wav_sound.set_filename("silence_57.wav");
				wav_sound.load();
			else
				odd_pic.set_part(1, flat_image);
				wav_sound.set_filename(stim_temp[2]);
				wav_sound.load();
			end;
			default.set_part(2, repeattxt);
			default.set_part(3, traintxt);
			loop
			until false begin
				oddball_train.present();
				repeat_train.present();
				if response_manager.last_response() == 2 then
					break
				end;
			end;
			default.set_part(2, nada);
			default.set_part(3, nada);
			default.present();
			wait_interval(300);
			pause_off.present();
			wait_interval(2000);
		else
			wav_sound.set_filename(stim_temp[6]);
			bmp_image.set_filename(stim_temp[5]);
			wav_sound.load();
			bmp_image.load();
			av_aud_evt.set_port_code(int(stim_temp[1]));
			code2.set_port_code(int(stim_temp[2]));
			code3.set_port_code(int(stim_temp[3]));
			code4.set_port_code(int(stim_temp[4]));
			av_trl.present();
			term.print_line(stims.count()-j);
			isi = random(1200,2400);
			wait_interval(isi);
		end;
	j = j + 1;
	end;
	pause_on.present();
	if i < nblocks then
		counttxt1.set_caption( "You have completed " + string(i) + " out of " + string(nblocks) + " blocks" );
		counttxt1.redraw();
		term.print_line("Break Time");
		break_time.present();
	end;
i = i + 1;
end