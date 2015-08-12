
libname foo "C:\Users\mcui\Desktop\datavis\shiny\cahps_explorer\data";

data foo;
	do plan = 1 to 20; 
		do patient = 1 to 100; 
			rate_md = rand('norm',90,5); 
			c_access = rate_md - rand('norm', 5, 10);
			c_comm = rand('norm', 85, 7.5);
			c_spec = c_comm - rand('norm', 2, 1);
			m_hlth_promo = rand('norm', 50, 25);
			m_func = m_hlth_promo + rand('norm', 10, 20);
			m_sdm = rand('norm', 70, 15);
		output; 
		end;
	end;
run;

data foo2;
	length educ age ghs mhs $50;
	set foo;
	rand1 = rand('norm', 0, 1);
	if rand1 < -1.5 then ghs = 'Poor';
	else if -1.5 <= rand1 < -0.5 then ghs = 'Fair';
	else if -0.5 <= rand1 < 0.5 then ghs = 'Good';
	else if 0.5 <= rand1 < 1.5 then ghs = 'Very Good';
	else ghs = 'Excellent';

	rand2 = rand('norm', 0, 1);
	if rand2 < -1.5 then mhs = 'Poor';
	else if -1.5 <= rand2 < -0.5 then mhs = 'Fair';
	else if -0.5 <= rand2 < 0.5 then mhs = 'Good';
	else if 0.5 <= rand2 < 1.5 then mhs = 'Very Good';
	else mhs = 'Excellent';

	rand3 = rand('norm', 0, 1);
	if rand3 < -1.5 then age = "65 or younger";
	else if -1.5 <= rand3 < -0.5 then age = "65 to 69";
	else if -0.5 <= rand3 < 0.5 then age = "70 to 74";
	else if 0.5 <= rand3 < 1.5 then age = "75 to 79";
	else age = "80 or older";

	rand4 = rand('norm', 0, 1);
	if rand4 < -1.5 then educ = "Less than High School";
	else if -1.5 <= rand4 < -0.5 then educ = "High School Graduate or GED";
	else if -0.5 <= rand4 < 0.5 then educ = "Some College";
	else if 0.5 <= rand4 < 1.5 then educ = "College Degree";
	else educ = "More than College Degree";
	
	array cahps_score (*) c_access c_comm rate_md c_spec m_hlth_promo m_func m_sdm;
	do a = 1 to dim(cahps_score);
		if cahps_score(a) < 0 then cahps_score(a) = 0;
		if cahps_score(a) > 100 then cahps_score(a) = 100;
	end;
	drop a;

	if age = '65 or younger' then age64 = 1; else age64 = 0;
	if age = '65 to 69' then age6569 = 1; else age6569 = 0;
	if age = '75 to 79' then age7579 = 1; else age7579 = 0;
	if age = '80 or older' then age80 = 1; else age80 = 0;

	if educ = "High School Graduate or GED" then educ_hs = 1; else educ_hs = 0;
	if educ = "Some College" then educ_somecol = 1; else educ_somecol = 0;
	if educ = "College Degree" then educ_coll = 1; else educ_coll = 0;
	if educ = "More than College Degree" then educ_collmore = 1; else educ_collmore = 0;

	if ghs = "Excellent" then ghs_excel = 1; else ghs_excel = 0; 
	if ghs = "Very Good" then ghs_vgood = 1; else ghs_vgood = 0; 
	if ghs = "Fair" then ghs_fair = 1; else ghs_fair = 0; 
	if ghs = "Poor" then ghs_poor = 1; else ghs_poor = 0; 

	if mhs = "Excellent" then mhs_excel = 1; else mhs_excel = 0; 
	if mhs = "Very Good" then mhs_vgood = 1; else mhs_vgood = 0; 
	if mhs = "Fair" then mhs_fair = 1; else mhs_fair = 0; 
	if mhs = "Poor" then mhs_poor = 1; else mhs_poor = 0; 
	drop rand1 rand2 rand3 rand4;
run;

data foo.cahps_data;
	set foo2;
run;
