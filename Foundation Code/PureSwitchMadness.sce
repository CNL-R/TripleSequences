# Header section (set default parameters)
active_buttons = 2;
button_codes = 1,252;
pulse_width = 5;
write_codes = true;
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

text { caption = "Take a short break, press the '1' button when you are ready to proceed"; font_size = 20; font_color = 0,255,255;
} breaktxt;
text { caption = "a"; font_size = 20; font_color = 0,255,255;
} counttxt1;

picture { text breaktxt; x = 0; y = 0; text counttxt1; x = 0; y = -200;
} break_pic;
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

default.present();


array <int> block_order[] = {1,1,2,2,3,3,4,4,4,4,5,5,5,5,6,6,6,6,7,7,7,7,8,8,8,8,9,9,9,9};

block_order.shuffle();

loop
	int blocknum = 0;
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

if block_order[blocknum] == 4 then
	stimtype = random(1,2);
elseif block_order[blocknum] == 5 then
	stimtype = random(2,3);
elseif block_order[blocknum] == 6 then
	stimtype = random(1,2);
	if stimtype == 2 then stimtype = 3; end;
elseif block_order[blocknum] > 6 then
	last = 100;
end;

wait_interval(50);
pause_off.present();
default.present();
wait_interval(1500);

	loop
		int stimnum = 0;
	until
		stimnum == 50
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
			if stimtype == 1 then
				stimtype = 2;
				silent_se.set_port_code(23);
				silent_se.set_event_code("23");
			elseif stimtype == 2 then
				stimtype = 1;
				aud_se.set_port_code(22);
				aud_se.set_event_code("22");
			end;
		elseif block_order[blocknum] == 5 then
			if stimtype == 2 then
				stimtype = 3;
				av_aud_se.set_port_code(36);
				av_aud_se.set_event_code("36");
			elseif stimtype == 3 then
				stimtype = 2;
				silent_se.set_port_code(33);
				silent_se.set_event_code("33");
			end;
		elseif block_order[blocknum] == 6 then
			if stimtype == 1 then
				stimtype = 3;
				av_aud_se.set_port_code(34);
				av_aud_se.set_event_code("34");
			elseif stimtype == 3 then
				stimtype = 1;
				aud_se.set_port_code(32);
				aud_se.set_event_code("32");
			end;
		elseif block_order[blocknum] > 6 then
			if block_order[blocknum] == 7 then
				stimtype = random(1,2);
				
				if stimtype == 1 then
					aud_se.set_port_code(last+3);
					aud_se.set_event_code(string(last+3));
					last = 4
				elseif stimtype == 2 then
					silent_se.set_port_code(last+6);
					silent_se.set_event_code(string(last+6));
					last = 2
				elseif stimtype == 3 then
					av_aud_se.set_port_code(last+9);
					av_aud_se.set_event_code(string(last+9));	
					last = 3
				end
				
			elseif block_order[blocknum] == 8 then
				stimtype = random(2,3);
				
				if stimtype == 1 then
					aud_se.set_port_code(last+3);
					aud_se.set_event_code(string(last+3));
				last = 44
				elseif stimtype == 2 then
					silent_se.set_port_code(last+6);
					silent_se.set_event_code(string(last+6));
					last = 42
				elseif stimtype == 3 then
					av_aud_se.set_port_code(last+9);
					av_aud_se.set_event_code(string(last+9));	
					last = 43
				end
				
			elseif block_order[blocknum] == 9 then
				stimtype = random(1,2);
				
				if stimtype == 2 then stimtype = 3 end;
				
				if stimtype == 1 then
					aud_se.set_port_code(last+3);
					aud_se.set_event_code(string(last+3));
					last = 54
				elseif stimtype == 2 then
					silent_se.set_port_code(last+6);
					silent_se.set_event_code(string(last+6));
					last = 52
				elseif stimtype == 3 then
					av_aud_se.set_port_code(last+9);
					av_aud_se.set_event_code(string(last+9));	
					last = 53
				end
			end;
		
		end;
		
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
			int isi = random(1000,2500);
		until
			clock.time() - time > isi
		begin
		end
	end;
	
	wait_interval(50);
	pause_on.present();
	wait_interval(50);

end