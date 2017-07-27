#Declaring parameters
active_buttons = 1; # Number of Buttons Used
button_codes = 1; # Button Code (Tag Number)

#refering the PCL file associated with this scenario file
pcl_file = "Visual_Control_File_et.pcl";

#Duration of Port Code (Tag Number) in milliseconds
pulse_width = 5;                                  

#Send and Register Codes
write_codes = true;     

#Type of Trials Used
response_matching = simple_matching;
scenario_type = trials;

#writing a log file
no_logfile = false;

#Setting Background Color to Black
default_background_color = 50, 50, 50;

#Starting Scenario
begin;           

text { caption = "+"; font_size = 10; font_color = 255,255,0; } my_cross;
#Declaring, Creating, and Preloading the stimuli
bitmap {filename = "red_circle505050.bmp";  preload = true; width = 200; height = 200;} circle;
wavefile {filename = "1000_57.wav"; preload = true;} wave_1000;
wavefile {filename = "silence_57.wav"; preload = true;} silencioso;

#Creating Picture and Sound Objects That Will be Used for loading the stimuli
picture{ bitmap circle; x = 0; y = 100;
         text my_cross; x = 0; y = 0; }change;   

picture{ text my_cross; x = 0; y = 0; }default;
sound { wavefile wave_1000; } my_sound;   
sound {wavefile silencioso;} silent;                                                                      

#Sound Trial
#trial
#{  stimulus_event { picture default;           
#                    time = 0; duration = 60;
#                    code = "sound alone"; port_code = 3;
#                    } vis3_se;
#   stimulus_event { sound my_sound; time = 0;}aud3_se;
#}aud;

#trial
#{     stimulus_event { sound my_sound; time = 0;code = "sound alone"; port_code = 3;}aud3_se;
#}aud;
#Visual Trial
trial
{
	stimulus_event{
      picture change; #Picture Object Associated with trial
      time = 0; #After Calling Trial How much time to wait to present stimuli 
      duration = 52;
     # code = "5"; # Code sent to logfile
     # port_code = 5;   #Code sent to parallel port  
		} vis_se;
	stimulus_event{
		sound silent;
		time = 0;
		code = "5";
		port_code = 5;
		} visaud_se;
} vis;               

trial
{  
   
   stimulus_event{
		picture change;           
		time = 0; duration = 52;
		#code = "3"; port_code = 3;
		} vis2_se;
	stimulus_event {
		sound my_sound; time = 0;  
		code = "3"; port_code = 3;
		} aud2_se;
  
} both;      #Both Conditions Trial

trial #Auditory trial
{  
   stimulus_event{
		sound my_sound;
		code = "4"; port_code=4;
		time = 0;                     
		} aud3_se;
   stimulus_event {
		picture default;
		} vis3_se;
   
} aud;