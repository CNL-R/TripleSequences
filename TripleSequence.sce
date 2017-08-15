# Header section (set default parameters)
active_buttons = 2;
button_codes = 1,252;
pulse_width = 5;
write_codes = true;
scenario_type = trials;
no_logfile = false;
response_matching = simple_matching;
default_background_color = 50, 50, 50;

#SDL portion (create objects and trials)
begin;
bitmap { filename = "red_circle505050.bmp";  preload = true; 
		  width = 200; height = 200;} vis_stim;
wavefile {filename = "1000_57.wav"; preload = true;} aud_stim;
wavefile {filename = "silence_57.wav"; preload = true;} no_tone;
text { caption = "+"; font_size = 16; font_color = 255,255,255; } fixcross;

text { caption = "Take a short break, press the '1' button when you are ready to proceed"; font_size = 20; font_color = 0,255,255;
} breaktxt;
text { caption = "a"; font_size = 20; font_color = 0,255,255;
} counttxt1;

picture { text breaktxt; x = 0; y = 0; text counttxt1; x = 0; y = -200;
} break_pic;
picture { text fixcross; x = 0; y = 0;} just_fix;
picture { text fixcross; x = 0; y = 0;} default;
picture { bitmap vis_stim; x = 0; y = 150;
			text fixcross; x=0; y = 0;} vis_on;
sound { wavefile no_tone;} silent;
sound { wavefile aud_stim;} aud_on;

trial {
			stimulus_event {picture vis_on; time = 0; duration = 52;} vis_se;
			stimulus_event {sound silent; time = 0;} silent_se;
		} vis;

trial {
			stimulus_event {picture just_fix; time = 0;} fix_se;
			stimulus_event {sound aud_on; time = 0;} aud_se;
		} aud;
trial {
			stimulus_event {picture vis_on; time = 0; duration = 52;} av_vis_se;
			stimulus_event {sound aud_on; time = 0;} av_aud_se;
		} av;
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 2;
		stimulus_event {
		picture break_pic;
		target_button = 2;
		} break_event;
	} break_time;
		
trial { nothing{}; time = 0; port_code = 253;} pause_off;
trial { nothing{}; time = 0; port_code = 254;} pause_on;

#PCL portion (run trials and manipulate objects)
begin_pcl;

int stimtype;
int last;
string filebase = "block";
array <int> stims[0];				#Create array for all stims listed in file

default.present();

array <int> block_order[] = {1,2,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4};

# 1 - Pure Visual Block
# 2 - Pure Auditory Block
# 3 - Pure AV Block
# 4 - Mixed Blocks (27 of them)

block_order.shuffle();
string filename; 
loop
	int blocknum = 0;
	int mixedblocknum = 0;
until
	blocknum == block_order.count()+1
begin
	blocknum = blocknum + 1;

if blocknum < block_order.count()+1 then
	counttxt1.set_caption( "You are about to start block " + string(blocknum) + " out of " + string(block_order.count()) + " blocks" );
	counttxt1.redraw();
	term.print_line("Break Time");
	break_time.present();
end;

if block_order[blocknum] == 1 then
	stimtype = 1;
elseif block_order[blocknum] == 2 then
	stimtype = 2;
elseif block_order[blocknum] == 3 then
	stimtype = 3;
elseif block_order[blocknum] == 4 then
	mixedblocknum = mixedblocknum + 1;
	stims.resize(0);
	filename = filebase + string(mixedblocknum) + ".txt";# Load in stimulus file names from text file
	input_file stimsf = new input_file; #Create input_file object
	stimsf.open(filename);					#Open file defined at top into input_file object
	loop
		int sname = stimsf.get_int();#Read the contents of the file into the stims array
	until !stimsf.last_succeeded() begin
		stims.add(sname);
		sname = stimsf.get_int();
		
	end;
	stimsf.close();							#Close the file
	int nstims = stims.count();			#number of stimuli to be presented per block`
end;

wait_interval(50);
pause_off.present();
default.present();
wait_interval(1500);
	
loop #portcode logic loop
	int stimnum = 0;
until
	stimnum == 54
begin
	stimnum = stimnum + 1;
	if block_order[blocknum] < 4 then
		stimtype = block_order[blocknum];
		aud_se.set_port_code(block_order[blocknum]+1);
		aud_se.set_event_code(string(block_order[blocknum]+1));
		silent_se.set_port_code(block_order[blocknum]+1);
		silent_se.set_event_code(string(block_order[blocknum]+1));
		av_aud_se.set_port_code(block_order[blocknum]+1);
		av_aud_se.set_event_code(string(block_order[blocknum]+1));	
	elseif block_order[blocknum] == 4 then
		stimtype = stims[stimnum];
		if stimtype == 1 then
			aud_se.set_port_code(last+3);
			aud_se.set_event_code(string(last+3));
			last = 4;
		elseif stimtype == 2 then
			silent_se.set_port_code(last+6);
			silent_se.set_event_code(string(last+6));
			last = 2
		elseif stimtype == 3 then
			av_aud_se.set_port_code(last+9);
			av_aud_se.set_event_code(string(last+9));	
			last = 3
		end;
	end;
		
		#Stimulus presentation loop
		if stimtype == 1 then
			aud.present();
		elseif stimtype == 2 then
			vis.present();
		elseif stimtype == 3 then	
			av.present();
		end;
		term.print(stimnum);
		term.print("\n");
		loop
			int time = clock.time();
			int isi = random(1000,2400);
		until
			clock.time() - time > isi
		begin
		end;
end;

wait_interval(50);
pause_on.present();
wait_interval(50);
	

end;