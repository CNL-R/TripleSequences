# Header section (set default parameters)
active_buttons = 1;
button_codes = 1;
pulse_width = 5;
#write_codes = true;
response_matching = simple_matching;
scenario_type = trials;
no_logfile = false;
default_background_color = 50, 50, 50;

#SDL portion (create objects and trials)
begin;

bitmap { filename = "red_circle505050.bmp";  preload = true; 
		  width = 200; height = 200;} vis_stim1;
wavefile {filename = "1000_57.wav"; preload = true;} aud_tone1;
wavefile {filename = "silence_57.wav"; preload = true;} no_tone;
text { caption = "+"; font_size = 16; font_color = 255,255,255; } fixcross;
picture { text fixcross; x = 0; y = 0;} just_fix;
picture { text fixcross; x = 0; y = 0;} default;
picture { text fixcross; x=0; y = 0;
			bitmap vis_stim1; x = 0; y = 150;} vis_on;
sound { wavefile no_tone;} silent;
sound { wavefile aud_tone1;} aud_on;

trial {
		stimulus_event { picture vis_on; time = 0;
							duration = 52;
							} vis_se;
		stimulus_event { sound silent; time = 0;
							} silent_se;
		} vis;
trial {
		stimulus_event { picture just_fix; time = 0;
							} fix_se;
		stimulus_event {sound aud_on; time = 0;
							} aud_se;
		} aud;
trial {
		stimulus_event { picture vis_on; time = 0;
							duration = 52;
							} av_vis_se;
		stimulus_event {sound aud_on; time = 0;
							} av_aud_se;
		} av;
#PCL portion (run trials and manipulate objects)
begin_pcl;

int stimtype;

default.present();

loop
	int stimnum = 0;
	int last = 0;
until
	stimnum == 15
begin
	
	loop
		int time = clock.time();
		int isi = random(1000,2500);
	until
		clock.time() - time > isi
	begin
	end;
	
	stimnum = stimnum + 1;
	stimtype = random(1,3);	
	if stimtype == 1 then
		aud_se.set_port_code(last+3);
		aud_se.set_event_code(string(last+3));
		aud.present();
		last = 4
	elseif stimtype == 2 then
		silent_se.set_port_code(last+6);
		silent_se.set_event_code(string(last+6));
		vis.present();
		last = 2
	elseif stimtype == 3 then
		av_aud_se.set_port_code(last+9);
		av_aud_se.set_event_code(string(last+9));	
		av.present();
		last = 3
	end;
	term.print(stimnum);
	term.print("\n"); 
end