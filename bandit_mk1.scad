$fn = 100;

cross_section = true;

band_post_h = 7.0;
catch_w = 2.5;

post_thickness = 6.0;

wall_thickness = 2.5;
padding = 0.5;
loose_padding = 1.5 * padding;
print_spacing = 2.0;

total_barrel_l = 100.0;

grip_h = 45.0;
grip_w = 40.0;
grip_angle_offset = grip_h * sin(17);

trigger_front_space = 7.5;
triger_exposed_w = 15.0;

cocker_l = 15.0;

trigger_face_h = 21.0;
trigger_h = trigger_face_h + (2 * wall_thickness);
tigger_notch_w = 3 * catch_w;
trigger_front_width = 17.5 + wall_thickness;
trigger_back_width = tigger_notch_w + (2 * wall_thickness);
trigger_total_w = trigger_front_width + tigger_notch_w + (2 * wall_thickness);

pin_r = 3.0;

pin_taper_h = 2.0;
pin_lip_h = 1.0;
pin_end_h = pin_taper_h + pin_lip_h;

pin_lip_w = 1.5 * padding;

pin_notch_w = 4.0;
pin_notch_h = pin_end_h + padding + wall_thickness;

pin_h = post_thickness + (4 * padding) + (2 * wall_thickness) + (2 * pin_end_h);
pin_flat_ratio = 1 / 3.0;
pin_flat_trim_h = (pin_flat_ratio * pin_r) + pin_lip_w;
pin_flat_trim_y_offset = -pin_flat_trim_h - pin_r + (pin_flat_ratio * pin_r);

trigger_wheel_catch_r = pin_r + loose_padding + (2 * wall_thickness) + band_post_h;
trigger_wheel_r = trigger_wheel_catch_r - (2 * catch_w);

trigger_catch_cylinder_r = pin_r + (1.5 * padding) + wall_thickness;

trigger_catch_to_wheel_offset = trigger_wheel_catch_r + 
		(trigger_catch_cylinder_r / 2.0) + loose_padding;
trigger_catch_lever_h = trigger_catch_to_wheel_offset - trigger_catch_cylinder_r; 

trigger_guard_angle_start = -trigger_front_width - trigger_front_space - 
		(2 * wall_thickness);
trigger_guard_top = -trigger_catch_cylinder_r - wall_thickness;

housing_thickness = post_thickness + (2 * wall_thickness) + (2 * padding);
housing_top = trigger_catch_to_wheel_offset + trigger_wheel_catch_r - band_post_h;
housing_back = (2 * trigger_wheel_r) + (2 * padding) + wall_thickness;
housing_bottom = -trigger_catch_cylinder_r - trigger_h - wall_thickness - padding;
housing_front = trigger_guard_angle_start - trigger_face_h - (2 * wall_thickness);

back_attachment_w = (post_thickness / 2.0) + (3 * padding) 
		+ (2 * pin_r) + (4 * wall_thickness);
back_attachment_h = 0.75 * (housing_top - housing_bottom);

grip_taper_h = grip_w - back_attachment_w;

front_attachment_w = (2 * padding) + (2 * pin_r) + (4 * wall_thickness);
front_attachment_h = housing_top - (3 * wall_thickness) 
		- (housing_bottom + trigger_face_h);

trigger_group_hollow_thickness = post_thickness + (2 * padding);

trigger_group_hollow_w = trigger_total_w + (2 * padding);
trigger_group_hollow_h = housing_top - housing_bottom;

trigger_hollow_w = trigger_total_w + wall_thickness + padding;
trigger_hollow_h = trigger_h + (2 * padding);

trigger_guard_cutter_back = triger_exposed_w - trigger_front_width;

housing_hollower_front = housing_front + front_attachment_w + wall_thickness
		+ (trigger_group_hollow_thickness / 2.0);
housing_hollower_back = -trigger_group_hollow_w + housing_back - (2 * wall_thickness)
		- (trigger_group_hollow_thickness / 2.0);
housing_hollower_top = housing_top - wall_thickness;
housing_hollower_bottom = housing_bottom + (4 * wall_thickness) + trigger_face_h
		+ (2 * padding);

// platter_for_printing_trigger_group();

// platter_for_printing_grip_and_barrel();

parts_for_design();

module parts_for_design() {
	color("green")
		translate([trigger_wheel_r, trigger_catch_to_wheel_offset, wall_thickness + padding])
		//rotate([0, 0, 55])
			make_trigger_wheel();

	// trigger wheel pin
	translate([trigger_wheel_r, trigger_catch_to_wheel_offset, -(2 * padding)])
		rotate([0, 0, -45])
			rotate([-90, 0, 0])
				translate([0, -(pin_h / 2.0) + wall_thickness, 
						-pin_r + (pin_flat_ratio * pin_r)])
					make_pin();

	color("red")
		translate([0, 0, wall_thickness + padding])
		//rotate([0, 0, 22.5])
			make_trigger_catch();

	// trigger catch pin
	translate([0, 0, -(2 * padding)])
		rotate([0, 0, -45])
			rotate([-90, 0, 0])
				translate([0, -(pin_h / 2.0) + wall_thickness, 
						-pin_r + (pin_flat_ratio * pin_r)])
					make_pin();

	color("blue")
		//translate([2.5, 0, 0])
		translate([0, -trigger_catch_to_wheel_offset, wall_thickness + padding])
			make_trigger();

	color("yellow")
		difference() {
			make_trigger_housing();

			if (cross_section) {
				translate([housing_front - 0.5, housing_bottom - 0.5, housing_thickness / 2.0])
					cube([housing_back - housing_front + back_attachment_w + 1, 
							housing_top - housing_bottom + 1, housing_thickness / 2.0 + 1]);
			}
		};

	translate([housing_front - padding + front_attachment_w,
			housing_top + padding - front_attachment_h, 0]) {
		color("brown")
			difference() {
				make_barrel();

				if (cross_section) {
					translate([-total_barrel_l - 0.5, -0.5, (housing_thickness / 2.0)])
						cube([total_barrel_l + 1, front_attachment_h + band_post_h + 1, 
								(housing_thickness / 2.0) + 1]);
				}
			}

		// barrel bottom pin
		translate([-pin_r - (2 * wall_thickness), 
				pin_r + (2 * wall_thickness) + padding, -(2 * padding)])
			rotate([0, 0, -45])
				rotate([-90, 0, 0])
					translate([0, -(pin_h / 2.0) + wall_thickness, 
							-pin_r + (pin_flat_ratio * pin_r)])
						make_pin();

		// barrel top pin
		translate([-pin_r - (2 * wall_thickness), front_attachment_h 
				- (3 * wall_thickness) - pin_r - (3 * padding), -(2 * padding)])
			rotate([0, 0, -45])
				rotate([-90, 0, 0])
					translate([0, -(pin_h / 2.0) + wall_thickness, 
							-pin_r + (pin_flat_ratio * pin_r)])
						make_pin();
	};

	translate([housing_back + (housing_thickness / 2.0) - wall_thickness, 
			housing_bottom, 0]) {
		color("purple")
			make_grip();

		// grip bottom pin
		translate([pin_r + padding + (2 * wall_thickness), 
				pin_r + padding + (2 * wall_thickness), -(2 * padding)])
			rotate([0, 0, -45])
				rotate([-90, 0, 0])
					translate([0, -(pin_h / 2.0) + wall_thickness, 
							-pin_r + (pin_flat_ratio * pin_r)])
						make_pin();

		// grip top pin
		translate([pin_r + padding + (2 * wall_thickness), 
				back_attachment_h - (2 * padding) - pin_r - (2 * wall_thickness), 
				-(2 * padding)])
			rotate([0, 0, -45])
				rotate([-90, 0, 0])
					translate([0, -(pin_h / 2.0) + wall_thickness, 
							-pin_r + (pin_flat_ratio * pin_r)])
						make_pin();
	}
};

module platter_for_printing_trigger_group() {
	translate([trigger_catch_lever_h - trigger_wheel_r, 
			trigger_catch_cylinder_r + trigger_wheel_catch_r + print_spacing, 0])
		rotate([0, 0, 90])
			make_trigger_wheel();

	translate([-trigger_catch_cylinder_r - trigger_catch_lever_h - (2 * print_spacing), 
			pin_h + (2 * print_spacing) + trigger_catch_cylinder_r, 0]) {
		translate([pin_r + pin_lip_w + print_spacing, (pin_h / 2.0), 0])
			make_pin();

		translate([-pin_r - pin_lip_w, (pin_h / 2.0), 0])
			make_pin();

		translate([pin_r + pin_lip_w + print_spacing, 
				-(pin_h / 2.0) - print_spacing, 0])
			make_pin();

		translate([-pin_r - pin_lip_w, -(pin_h / 2.0) - print_spacing, 0])
			make_pin();

		translate([(3 * (-pin_r - pin_lip_w)) - print_spacing, 
				-(pin_h / 2.0) - print_spacing, 0])
			make_pin();

		translate([(3 * (-pin_r - pin_lip_w)) - print_spacing, (pin_h / 2.0), 0])
			make_pin();
	};

	translate([-trigger_catch_cylinder_r, print_spacing, 0])
		rotate([0, 0, 90])
			make_trigger_catch();

	translate([0, -trigger_catch_to_wheel_offset, 0])
		make_trigger();

	translate([trigger_catch_lever_h + print_spacing, 0, 
			housing_back + back_attachment_w])
		rotate([0, 90, 0])
			make_trigger_housing();
};

module platter_for_printing_grip_and_barrel() {
	translate([-housing_thickness - (print_spacing / 2.0), print_spacing, 0])
		rotate([0, 90, 0])
			make_barrel();

	translate([housing_thickness + (print_spacing / 2.0), 0, 
			back_attachment_h -padding])
		rotate([-90, 0, 90])
			make_grip();
};

module make_grip() {
	difference() {
		// basic shape
		linear_extrude(height=housing_thickness)
			polygon([
					[0, 0],
					[0, back_attachment_h - padding],
					[back_attachment_w + wall_thickness, back_attachment_h - padding],
					[grip_w, back_attachment_h - padding - grip_taper_h],
					[grip_w + grip_angle_offset, -grip_h],
					[wall_thickness, -grip_h]
				]);

		// cut grip hollow
		translate([0, 0, wall_thickness])
			linear_extrude(height=trigger_group_hollow_thickness)
				polygon([
						[back_attachment_w - (trigger_group_hollow_thickness / 2.0) 
								+ padding + wall_thickness, -wall_thickness],
						[back_attachment_w - (trigger_group_hollow_thickness / 2.0) 
								+ padding + wall_thickness, back_attachment_h 
								- padding - wall_thickness],
						[back_attachment_w, back_attachment_h - padding - wall_thickness],
						[grip_w - wall_thickness, back_attachment_h - padding 
								- grip_taper_h - wall_thickness],
						[grip_w + grip_angle_offset - wall_thickness, -grip_h - 0.5],
						[2 * wall_thickness, -grip_h - 0.5],
						[wall_thickness, -wall_thickness]
					]);

		// cut bottom wall notch
		translate([-1, -padding, -1])
			cube([back_attachment_w - (trigger_group_hollow_thickness / 2.0) + padding + 1, 
					back_attachment_h + 1, wall_thickness + padding + 1]);

		// angle bottom wall notch
		translate([-padding, -padding, -(wall_thickness + padding)])
			rotate([0, -45, -90])
				cube([(sqrt(2) / 2.0) * (2 * (wall_thickness + padding)), 
						back_attachment_w - wall_thickness, 
						(sqrt(2) / 2.0) * (2 * (wall_thickness + padding))]);

		// cut top wall notch
		translate([-1, -padding, post_thickness + wall_thickness + padding])
			cube([back_attachment_w - (trigger_group_hollow_thickness / 2.0) + padding + 1, 
					back_attachment_h + 1, wall_thickness + padding + 1]);

		// angle top wall notch
		translate([-padding, -padding, -(wall_thickness + padding) + housing_thickness])
			rotate([0, -45, -90])
				cube([(sqrt(2) / 2.0) * (2 * (wall_thickness + padding)), 
						back_attachment_w - wall_thickness, 
						(sqrt(2) / 2.0) * (2 * (wall_thickness + padding))]);

		// cut bottom pin hole
		translate([pin_r + padding + (2 * wall_thickness), 
					pin_r + padding + (2 * wall_thickness), 0])
			make_pin_cutter(housing_thickness);

		// cut top pin hole
		translate([pin_r + padding + (2 * wall_thickness), 
				back_attachment_h - (2 * padding) - pin_r - (2 * wall_thickness), 0])
			make_pin_cutter(housing_thickness);
	};
};

module make_pin_cutter(height) {
	rotate([0, 0, -45])
		difference() {
			// shaft
			cylinder(height, pin_r + padding, pin_r + padding, [0, 0, 0]);

			// cut flat side
			translate([-pin_r, pin_flat_trim_y_offset - padding, 0])
				cube([2 * pin_r, pin_flat_trim_h, height]);
		};
};

module make_barrel() {
	difference() {
		rotate([90, 0, 180])
			union() {
				difference() {
					// barrel blank
					linear_extrude(height=front_attachment_h - padding)
						polygon([
								[0, 0],
								[0, housing_thickness],
								[front_attachment_w, housing_thickness],
								[total_barrel_l, housing_thickness - (wall_thickness + padding)],
								[total_barrel_l, wall_thickness + padding],
								[front_attachment_w, 0]
							]);

					// barrel bottom cutter
					translate([0, housing_thickness + 0.5, 0])
						rotate([90, 0, 0])
							linear_extrude(height=housing_thickness + 1)
								polygon([
										[front_attachment_w - padding, -0.5],
										[(total_barrel_l / 3.0) + 0.5, 
											(front_attachment_h / 2.0) - padding],
										[total_barrel_l + 0.5, (front_attachment_h / 2.0)
											- padding],
										[total_barrel_l + 0.5, -0.5]
									]);

					// cut attachment to housing
					translate([-0.5, wall_thickness, -0.5])
						cube([front_attachment_w - padding + 0.5, 
								housing_thickness - (2 * wall_thickness), 
								front_attachment_h - padding - wall_thickness + 0.5]);

					// angle barrel attachment notch
					translate([front_attachment_w - padding, 
							post_thickness + (2 * padding) + wall_thickness, -0.5])
						rotate([90, 0, 0])
							make_angle_cutter(front_attachment_h - padding 
									- wall_thickness + 0.5);
				}

				// front band post
				translate([(3 * total_barrel_l) / 4.0, 
						post_thickness + wall_thickness + padding, 
						front_attachment_h - padding - 1])
					rotate([90, 0, 0])
						linear_extrude(height=post_thickness)
							polygon([
									[0, 0],
									[total_barrel_l / 4.0, band_post_h + 1],
									[total_barrel_l / 4.0, 0]
								]);	
			}

		// bottom barrel connector pin hole
		translate([-pin_r - (2 * wall_thickness), 
				pin_r + padding + (2 * wall_thickness), -0.5])
			make_pin_cutter(housing_thickness + 1);

		// top barrel connector pin hole
		translate([-pin_r - (2 * wall_thickness), 
				front_attachment_h - (3 * padding) - pin_r - (3 * wall_thickness),
				-0.5])
			make_pin_cutter(housing_thickness + 1);
	};
};

module make_trigger_housing() {
	difference() {
		// trigger housing blank
		linear_extrude(height=housing_thickness)
			polygon([
					[trigger_guard_angle_start, housing_bottom],
					[housing_front, trigger_guard_top],
					[housing_front, housing_top],
					[housing_back, housing_top],
					[housing_back + back_attachment_w, 
							housing_bottom + back_attachment_h + wall_thickness],
					[housing_back + back_attachment_w, housing_bottom]
				]);

		// cut the main hollow for the trigger group
		translate([-trigger_group_hollow_w + housing_back - wall_thickness, 
				housing_bottom + wall_thickness, wall_thickness])
			cube([trigger_group_hollow_w, trigger_group_hollow_h, 
					trigger_group_hollow_thickness]);

		// trigger hollow cutter
		translate([trigger_back_width - trigger_hollow_w, 
				housing_bottom + wall_thickness, wall_thickness])
			cube([trigger_hollow_w, trigger_hollow_h, 
					trigger_group_hollow_thickness]);

		// cut trigger guard
		translate([wall_thickness, 2 * wall_thickness, -0.5])
			linear_extrude(height=housing_thickness + 1)
				polygon([
						[trigger_guard_angle_start, housing_bottom],
						[trigger_guard_angle_start - trigger_face_h,
								housing_bottom + trigger_face_h],
						[trigger_guard_cutter_back, housing_bottom + trigger_face_h],
						[trigger_guard_cutter_back, housing_bottom]
					]);

		// angle main trigger group hollow
		translate([-trigger_group_hollow_w + housing_back - wall_thickness, 
				housing_bottom + wall_thickness, wall_thickness])
			make_angle_cutter(housing_top - housing_bottom - wall_thickness + 1);

		// angle trigger guard
		translate([trigger_back_width - trigger_hollow_w, 
				housing_bottom + wall_thickness, wall_thickness])
			make_angle_cutter(trigger_hollow_h);

		// cut catch pin hole
		translate([0, 0, -0.5])
			make_pin_cutter(housing_thickness + 1);

		// cut trigger wheel pin hole
		translate([trigger_wheel_r, trigger_catch_to_wheel_offset, -0.5])
			make_pin_cutter(housing_thickness + 1);

		// cut attachment notch for grip
		translate([housing_back + (trigger_group_hollow_thickness / 2.0) - padding, 
				housing_bottom - 0.5, wall_thickness])
			union() {
				cube([back_attachment_w - (trigger_group_hollow_thickness / 2.0) 
								+ padding + 0.5, back_attachment_h + 0.5, 
						trigger_group_hollow_thickness]);

				make_angle_cutter(back_attachment_h + 0.5);
			}

		// cut grip top pin hole
		translate([housing_back + pin_r + (trigger_group_hollow_thickness / 2.0) 
				+ padding + (2 * wall_thickness), 
				housing_bottom + back_attachment_h - pin_r - (2 * padding)
				- (2 * wall_thickness), -0.5])
			make_pin_cutter(housing_thickness + 1);

		// cut grip bottom pin hole
		translate([housing_back + pin_r + (trigger_group_hollow_thickness / 2.0) 
				+ (2 * wall_thickness) + padding, housing_bottom + pin_r 
				+ padding + (2 * wall_thickness), -0.5])
			make_pin_cutter(housing_thickness + 1);

		// cut bottom side barrel notch
		translate([housing_front - 0.5, housing_top - front_attachment_h, -0.5])
			cube([front_attachment_w + 0.5, front_attachment_h + 0.5, 
					wall_thickness + padding + 0.5]);

		// cut top side barrel notch
		translate([housing_front - 0.5, housing_top - front_attachment_h - 0.5, 
				post_thickness + wall_thickness + padding])
			cube([front_attachment_w + 0.5, front_attachment_h + 0.5, 
					wall_thickness + padding + 0.5]);

		// cut top barrel notch
		translate([housing_front - 0.5, housing_top - wall_thickness - padding, 0])
			cube([front_attachment_w + 0.5, wall_thickness + padding + 0.5, 
					housing_thickness]);

		// cut barrel top pin hole
		translate([housing_front + pin_r + padding + (2 * wall_thickness), 
				housing_top - (2 * pin_r) - padding - (2 * wall_thickness), 
				0])
			make_pin_cutter(housing_thickness);

		// cut barrel bottom pin hole
		translate([housing_front + pin_r + padding + (2 * wall_thickness), 
				housing_top - front_attachment_h + pin_r + (2 * padding) 
				+ (2 * wall_thickness), 0])
			make_pin_cutter(housing_thickness);

		// cut notch for cocking lever
		translate([housing_back - wall_thickness - 0.5, 
				housing_top - trigger_wheel_r, wall_thickness])
			cube([(0.6 * cocker_l) + 0.5, trigger_wheel_r + 0.5, 
					trigger_group_hollow_thickness]);

		// hollow out space in front of trigger group
		translate([housing_hollower_front, housing_top - 
				(housing_hollower_top - housing_hollower_bottom) - wall_thickness, 
				wall_thickness])
			union() {
				cube([housing_hollower_back - housing_hollower_front, 
						housing_hollower_top - housing_hollower_bottom, 
						trigger_group_hollow_thickness]);

				make_angle_cutter(housing_hollower_top - housing_hollower_bottom);
			}

		// cut into hollow so the stl picks it up
		translate([housing_hollower_back - 0.5, 
				housing_hollower_bottom, wall_thickness])
			cube([wall_thickness + (trigger_group_hollow_thickness / 2.0) + 1, 
					wall_thickness, trigger_group_hollow_thickness]);
	};
};

module make_trigger() {
	difference() {
		// main trigger body
		linear_extrude(height=post_thickness)
			polygon([
				[0, -catch_w],
				[tigger_notch_w, -catch_w],
				[tigger_notch_w, trigger_catch_lever_h],
				[trigger_back_width, trigger_catch_lever_h],
				[trigger_back_width, trigger_catch_lever_h - trigger_h],
				[-trigger_front_width, trigger_catch_lever_h - trigger_h],
				[-trigger_front_width, trigger_catch_lever_h],
				[0, trigger_catch_lever_h]
			]);

		// cut rounded trigger front
		translate([-trigger_front_width - (trigger_h /  4.0), 
				-(trigger_face_h /  2.0) + trigger_catch_lever_h - wall_thickness, -0.5])
			cylinder(post_thickness + 1, trigger_h /  2.0, trigger_h / 2.0, [0, 0, 0]);
	};
};

module make_trigger_catch() {
	difference() {
		union() {
			make_scroll_catch();
	
			// main cylinder
			cylinder(post_thickness, trigger_catch_cylinder_r, 
					trigger_catch_cylinder_r, [0, 0, 0]);
		
			rotate([0, 0, 180])
				make_scroll_catch();
		}

		// cut pin hole
		translate([0, 0, -0.5])
			cylinder(post_thickness + 1, pin_r + loose_padding, 
					pin_r + loose_padding, [0, 0, 0]);
	};
};

module make_scroll_catch() {
	linear_extrude(height=post_thickness)
		polygon([
			[0, 0],
			[0, trigger_catch_to_wheel_offset],
			[-catch_w, trigger_catch_to_wheel_offset],
			[-trigger_catch_cylinder_r, 0],
			[0, 0]
		]);
};

module make_pin() {
	difference() {
		union() {
			translate([0, pin_h / 2.0, pin_r - (pin_flat_ratio * pin_r)])
				rotate([90, 0, 0])
					difference() {
						// shaft
						cylinder(pin_h, pin_r, pin_r, [0, 0, 0]);

						// cut flat side
						translate([-pin_r, pin_flat_trim_y_offset, -0.5])
							cube([2 * pin_r, pin_flat_trim_h, pin_h + 1]);
					}

			// pin end
			translate([0, -(pin_h / 2.0) + pin_end_h, 0])
				make_pin_end();

			// pin end
			translate([0, (pin_h / 2.0) - pin_end_h, 0])
				rotate([0, 0, 180])
					make_pin_end();
		}

		// cut notch
		translate([0, (pin_h / 2.0) - pin_notch_h, 0])
			make_pin_notch_cutter();

		// cut notch
		translate([0, -(pin_h / 2.0) + pin_notch_h, 0])
			rotate([0, 0, 180])
				make_pin_notch_cutter();

		// flatten pin end top
		translate([-(pin_r + pin_lip_w), (pin_h / 2.0) - padding - pin_end_h, 
				wall_thickness])
			cube([2 * (pin_r + pin_lip_w), pin_end_h + padding + 1, 
					pin_r + pin_lip_w]);

		// flatten pin end top
		translate([-(pin_r + pin_lip_w), -(pin_h / 2.0) - 1, 
				wall_thickness])
			cube([2 * (pin_r + pin_lip_w), pin_end_h + padding + 1, 
					pin_r + pin_lip_w]);
	};
};

module make_pin_notch_cutter() {
	translate([0, pin_notch_w / 2.0, -0.5])
		union() {
			translate([-pin_notch_w / 2.0, 0, 0])
				cube([pin_notch_w, pin_notch_h - (pin_notch_w / 2.0) + 0.1, 
						2 * (pin_r + pin_lip_w) + 1]);

			cylinder(2 * (pin_r + pin_lip_w) + 1, pin_notch_w / 2.0, 
					pin_notch_w / 2.0, [0, 0, 0]);
		};
};

module make_pin_end() {
	translate([0, 0, pin_r - (pin_flat_ratio * pin_r)])
		rotate([90, 0, 0])
			difference() {
				union() {
					// taper
					translate([0, 0, pin_lip_h])
						cylinder(pin_taper_h, pin_r + pin_lip_w, pin_r, [0, 0, 0]);

					// lip
					cylinder(pin_lip_h, pin_r + pin_lip_w, pin_r + pin_lip_w, [0, 0, 0]);
				}

				// cut flat side
				translate([-(pin_r + pin_lip_w), pin_flat_trim_y_offset, -0.5])
					cube([2 * (pin_r + pin_lip_w), pin_flat_trim_h, pin_end_h + 1]);
			};
};

module make_trigger_wheel() {
	union() {
		difference() {
			union() {
				// trigger wheel catch
				difference() {
					cylinder(post_thickness, trigger_wheel_catch_r, 
							trigger_wheel_catch_r, [0, 0, 0]);
		
					translate([0, -trigger_wheel_catch_r, -0.5])
						cube([trigger_wheel_catch_r, 2 * trigger_wheel_catch_r, 
							post_thickness + 1]);

					translate([-trigger_wheel_catch_r, -trigger_wheel_catch_r, -0.5])
						cube([trigger_wheel_catch_r + 0.5, trigger_wheel_catch_r, 
								post_thickness + 1]);
				}
					
				// main trigger wheel cylinder
				cylinder(post_thickness, trigger_wheel_r, trigger_wheel_r, [0, 0, 0]);
			}
		
			// cut band post
			translate([0, trigger_wheel_catch_r - band_post_h, -0.5])
				cube([trigger_wheel_r, band_post_h, post_thickness + 1]);

			// cut pin hole
			translate([0, 0, -0.5])
				cylinder(post_thickness + 1, pin_r + loose_padding, 
						pin_r + loose_padding, [0, 0, 0]);
		}

		// cocking lever
		linear_extrude(height=post_thickness)
			polygon([
				[pin_r + loose_padding, 0],
				[pin_r + loose_padding, trigger_wheel_r - wall_thickness],
				[trigger_wheel_r + cocker_l, trigger_wheel_r + wall_thickness],
				[trigger_wheel_r + cocker_l, trigger_wheel_r],
				[trigger_wheel_r, 0]
			]);
	};
};

module post_round_cutter() {
	rotate([0, -90, -90])
		difference() {
			cube([post_thickness, post_thickness, band_post_h]);
	
			cylinder(band_post_h, post_thickness, post_thickness, [0, 0, 0]);
		};
};

module make_angle_cutter(height) {
	rotate([0, -45, 0])
		cube([(sqrt(2) / 2.0) * trigger_group_hollow_thickness, height, 
				(sqrt(2) / 2.0) * trigger_group_hollow_thickness]);
};

