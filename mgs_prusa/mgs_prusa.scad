
include<configuration.scad>
include<nema_motor.scad>
include <shapes.scad>
include <lib-teardrop.scad>

$fn=36;
gear_module = 0.5;

motor_gear_teeth = 14;
motor_gear_mounting_part_length=7;
motor_gear_mounting_part_dia = 10;
motor_gear_gear_length=6;

driven_gear_teeth=80;
driven_gear_length=4;
driven_gear_hub_length=4;
driven_gear_hub_dia = 20;
driven_shaft_length=40;

filament_drive_gear_teeth = 20;
filament_drive_gear_length = 5;
filament_drive_gear_hub_length=7.8;
filament_drive_gear_hub_dia = 10;

shafts_distance=(gear_module*(driven_gear_teeth+motor_gear_teeth))/2;
echo(shafts_distance);

bearing625_OD=16.25;
bearing625_height=5;
bearing_wall=1.5;

mounting_plate_A_height=7;

base_plate_height=7;
base_plate_width=63.5;
base_plate_depth=gear_module*driven_gear_teeth+2;

filament_OD=3;
filament_hole_zpos=24+filament_drive_gear_hub_length;
filament_hole_offset=(filament_OD+filament_drive_gear_teeth*gear_module)/2;

hotend_diameter = 17;
bot_hex=7.5;

$fn = 120;
drive_offset=1;

rotate(a=90,v=[0,1,0]){
 //   translate([-shafts_distance/2-drive_offset,0,-(motor_height)/2])nema();
//	translate([-shafts_distance/2-drive_offset,0,5.5])motor_gear();
//	translate([shafts_distance/2-drive_offset,0,-0.1])driven_gear();
//	translate([-100,filament_hole_offset,filament_hole_zpos])rotate([0,90,0])filament();
//	translate([shafts_distance/2-2,3+(filament_drive_gear_teeth*gear_module+608_diam)/2,21.4+7])rotate([0,0,0])bearing_608();//idler bearing

	translate([shafts_distance/2,0,0])mounting_plate();
//	translate(v=[44,13,46]) rotate(a=90,v=[0,0,1]) rotate(a=180,v=[0,1,0]) wadeidler();
}

module mounting_plate(){
	difference(){
		union(){
			translate([-shafts_distance-drive_offset,0,mounting_plate_A_height/2])color(PlasticBlue)cube([motor_OD,gear_module*driven_gear_teeth+2,mounting_plate_A_height],center=true);//motor mount
			difference(){
				// big motor mount wall
				translate([0,0,mounting_plate_A_height/2])color(PlasticGreen)cube([gear_module*driven_gear_teeth+2,gear_module*driven_gear_teeth+2,mounting_plate_A_height],center=true);//motor mount
				// edge cutout for better access to the hinge and extruder mounting bolt 				
				translate([-2,21,0]) rotate(a=-20,v=[0,0,1]) cube(size=[30,10,10]);	
			
			}

			translate([-drive_offset,0,0]){
				//bearing holder/motor:
				translate(v=[0,0,0]) bearing_post(22,bearing625_OD,bearing625_height,6);		

				//bearing holder/idler
				translate(v=[0,0,35+bearing625_height+6+5]) rotate(a=180,v=[1,0,0]) bearing_post(22,bearing625_OD,bearing625_height,4,1);		
			}	
			difference(){
				translate([(gear_module*driven_gear_teeth+2+base_plate_height)/2-0.01,0,filament_hole_zpos])color(PlasticBlue)base_plate();
				translate(v=[-50,-18,mounting_plate_A_height])rotate(a=90,v=[1,0,0])cube(size=[100,100,5]);			
			}		
			// idler hinge mount			
			translate(v=[11,15,26]) difference(){
				cube(size=[10+base_plate_height,9,12]);
				translate(v=[4,4.5,-1]) cylinder(r=1.7,h=15);	
			}
	
			// big idler wall
			difference(){
				union(){
					translate(v=[21,-18, 19]) rotate(a=90,v=[0,0,1]) cube(size=[7,45,28+4]);
					// connect walls for structural reinforcement				
					translate(v=[21,-18, 7]) rotate(a=90,v=[0,0,1]) cube(size=[7,3,12]);				
					translate(v=[-20,-18, 7]) rotate(a=90,v=[0,0,1]) cube(size=[6,4,12]);
				}
				translate(v=[-17,30,24]) rotate(a=90, v=[1,0,0]){		
					cylinder(r=2.2, h=60);		
					translate(v=[0,0,50]) hexagon(bot_hex,12);					
				}
				translate(v=[-17,30,40]) rotate(a=90, v=[1,0,0]){
					 cylinder(r=2.2, h=60);		
					translate(v=[0,0,50]) hexagon(bot_hex,12);	
				}


			}
		}

		translate([-1,0,0]){
			translate([0,0,-1])cylinder(r=(bearing625_OD-3)/2,h=driven_shaft_length*2);//driven shaft cutout
		}
		// hole extend for extruder mount
		// translate([6,16,9]) rotate([0,90,0]) cylinder(r=7.5/2,h=15);

		translate([-shafts_distance-drive_offset,0,0]){
			translate([0,0,7.5])rotate(a=90,v=[0,1,0])rotate(a=180,v=[1,0,0])teardrop(pdiam(motor_flange_dia+2)/2,mounting_plate_A_height+1); // motor flange cutout
			

			//mounting screw holes for motor:
			translate([motor_mounting_hole_distance/2,motor_mounting_hole_distance/2,-0.5])cylinder(r=motor_mounting_hole_diam/2,h=mounting_plate_A_height+1);
			translate([-motor_mounting_hole_distance/2,motor_mounting_hole_distance/2,-0.5])cylinder(r=motor_mounting_hole_diam/2,h=mounting_plate_A_height+1);
			translate([-motor_mounting_hole_distance/2,-motor_mounting_hole_distance/2,-0.5])cylinder(r=motor_mounting_hole_diam/2,h=mounting_plate_A_height+1);
			// this one is not accessable
			//translate([motor_mounting_hole_distance/2,-motor_mounting_hole_distance/2,-0.5])cylinder(r=motor_mounting_hole_diam/2,h=mounting_plate_A_height+1);
		}
	}
}

module bearing_post(height, bearing_diameter, bearing_height, wall_thickness=3,extra_cutout=0){
	total_height = bearing_height+wall_thickness;	
	difference(){
		union(){
			translate(v=[height/2,0,total_height/2]) cube([height, bearing_diameter*1.5, total_height],center=true);
			cylinder(r=bearing_diameter*1.5/2,h=total_height);
		}
		translate(v=[0,0,wall_thickness-extra_cutout]) cylinder(r=bearing_diameter/2, h=bearing_height+extra_cutout);
	}
}



module base_plate(){
	difference(){
		cube([base_plate_height,base_plate_depth,base_plate_width],center=true);	
		translate([-10,filament_hole_offset,0]){
			rotate(a=23, v=[1,0,0]){
				//wades mounting holes:
				translate([0,0,25])rotate([0,90,0])cylinder(r=4/2,h=20);
				translate([0,0,-25])rotate([0,90,0])cylinder(r=4/2,h=20);
			}			
			// hotend cutout
			rotate([0,90,0]) cylinder(r=hotend_diameter/2,h=20);
		}
		
	}
}




module motor_gear(){
	color(Stainless)cylinder(r1=motor_gear_mounting_part_dia/2,r2=(gear_module*motor_gear_teeth+1)/2,h=motor_gear_mounting_part_length);
	translate([0,0,motor_gear_mounting_part_length])color(Steel)cylinder(r=(gear_module*motor_gear_teeth)/2,h=motor_gear_gear_length);
}

module driven_gear(){
	translate(v=[0,0,45]) rotate(a=180,v=[1,0,0]) driven_shaft();
	//translate([0,0,m5_cap_H])color(Silver)cylinder(r=9.75/2,h=1.05);//washer
	translate([0,0,m5_cap_H])bearing_625();
	translate([0,0,m5_cap_H+bearing625_height])color(Silver)cylinder(r=9.75/2,h=1.0);//washer
	translate([0,0,m5_cap_H+bearing625_height+((1.0+0.05)*1)])color(Silver)cylinder(r=9.75/2,h=1.0);//washer
	translate([0,0,m5_cap_H+bearing625_height+((1.0+0.05)*2)])color(Silver)cylinder(r=9.75/2,h=1.0);//washer
	translate([0,0,m5_cap_H+bearing625_height+((1.0+0.05)*3)])big_gear();
	translate([0,0,m5_cap_H+bearing625_height+((1.0+0.05)*3)+driven_gear_length+driven_gear_hub_length]) translate(v=[0,0,8]) filament_gear();

//	translate([0,0,m5_cap_H+bearing625_height+((1.0+0.05)*3)+driven_gear_length+driven_gear_hub_length+filament_drive_gear_length+filament_drive_gear_hub_length+bearing_wall])bearing_625();
}

//driven gear:
module big_gear(){
	color(Steel)cylinder(r=(gear_module*driven_gear_teeth)/2,h=driven_gear_length);
	translate([0,0,driven_gear_length])color(Stainless)cylinder(r=driven_gear_hub_dia/2,h=driven_gear_hub_length);
}

module filament_gear(){
	color(Steel)cylinder(r=(gear_module*filament_drive_gear_teeth)/2,h=filament_drive_gear_length);
	translate(v=[0,0,filament_drive_gear_length])color(Stainless)cylinder(r=filament_drive_gear_hub_dia/2,h=filament_drive_gear_hub_length);
}

module driven_shaft(){
	color(BlackPaint)cylinder(r=m5_cap/2,h=m5_cap_H);
	translate([0,0,m5_cap_H])color(BlackPaint)cylinder(r=m5_diam/2,h=driven_shaft_length);
}

module bearing_625() {
	color(Brass)cylinder(r=bearing625_OD/2, h=bearing625_height);
}

module bearing_608(){
	color(Brass)cylinder(r=608_diam/2,h=608_H);
}

module filament(){
	color(PlasticRed)cylinder(r=3/2,h=200);
}




