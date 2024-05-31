main script for Q1

% ************ Question 1 **********
clear; 

uws_t1 = 25;
uws_t2 = 29; 
uws_t3 = 40; 
uws_t4 = 30; 
uws_t5 = 30; 
uws_t6 = 30; 
uws_t7 = 60;
uws_t8 = 20; 
uws_t9 = 30; 
uws_t10 = 20; 
uws_t11 = 40;



S1 = texture_synthesis_v1('texture1.jpg',uws_t1,2,1/3);
save S1;

time_t2_start = datestr(now,'HH:MM:SS');
S2 = texture_synthesis_v1('texture2.jpg',uws_t2,2,1/3);
save S2;
 
time_t3_start = datestr(now,'HH:MM:SS');
S3 = texture_synthesis_v1('texture3.jpg',uws_t3,2,1/3);
save S3; 

time_t4_start = datestr(now,'HH:MM:SS');
S4 = texture_synthesis_v1('texture4.jpg',uws_t4,2,1/3);
save S4;

time_t5_start = datestr(now,'HH:MM:SS');
S5 = texture_synthesis_v1('texture5.jpg',uws_t5,2,1/3);
save S5_4;

time_t6_start = datestr(now,'HH:MM:SS');
S6 = texture_synthesis_v1('texture6.jpg',uws_t6,2,1/3);
save S6_4;

time_t7_start = datestr(now,'HH:MM:SS');
S7 = texture_synthesis_v1('texture7.jpg',uws_t7,1.15,1/3);
save S7;

time_t8_start = datestr(now,'HH:MM:SS');
S8 = texture_synthesis_v1('texture8.jpg',uws_t8,1.4,1/3);
save S8_4;

time_t9_start = datestr(now,'HH:MM:SS');
S9 = texture_synthesis_v1('texture9.jpg',uws_t9,1.35,1/3);
save S9_4;

time_t10_start = datestr(now,'HH:MM:SS');
S10 = texture_synthesis_v1('texture10.jpg',uws_t10,1.35,1/3);
save S10;

time_t11_start = datestr(now,'HH:MM:SS');
S11 = texture_synthesis_v1('texture11.jpg',uws_t11,1.35,1/3);
save S11;


% ******** Question 2 *************

clear;
patch_match('rubik_1.jpg','rubik_3.jpg');
patch_match('flower_1.jpg','flower_2.jpg');
