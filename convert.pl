#!/usr/bin/perl

@image_info = [];
$image_file = "";
%object_set = ();

while(<>)
{
	chomp($_);

	if($_ =~ m/^Image filename/)
	{
		my @parts = split(/ +: +/, $_);
		$image_file = $parts[1];
	}
	elsif($_ =~ m/^Image size/)
        {
		my @parts = split(/ +: +/, $_);
		@image_info = split(/ +x +/, $parts[1]);
        }
	elsif($_ =~ m/^Bounding box for object ([0-9]+) "PASperson" \(Xmin, Ymin\) - \(Xmax, Ymax\) : \(([0-9]+), ([0-9]+)\) - \(([0-9]+), ([0-9]+)\)/)
        {
		my @parts = ($2,$3,$4,$5);
                $object_set{$1} = \@parts;
        }
}

print "{\n   \"file\": $image_file,\n   \"image_size\": [\n      {\n         \"width\": $image_info[0],\n         \"height\": $image_info[1],\n         \"depth\": $image_info[2]\n      }\n   ],\n   \"annotations\": [\"\n";

foreach my $object (keys(%object_set))
{
	$left = $object_set{$object}[0];
	$top = $object_set{$object}[3];
	$width = $object_set{$object}[2] - $object_set{$object}[0];
	$height = $object_set{$object}[3] - $object_set{$object}[1];
	print "      {\n         \"class_id\": 0,\n         \"left\": $left,\n         \"top\": $top,\n         \"width\": $width,\n         \"height\": $height\n      },\n";
}

print "   ],\n   \"categories\": [\n      {\n         \"class_id\": 0,\n         \"name\": \"person\"\n      }\n   ]\n}\n";
