#!/usr/bin/perl

my $inputParam = $ARGV[0];
my $separatorForFile = "New file --->";

if ($inputParam =~ m/\.txt/) {

	# Parse file flow

	# Get folder path from file path
	my @folderPathArray = split('/', $inputParam);
	pop(@folderPathArray);
	my $folderPath = join('/', @folderPathArray);

	# Open file
	open(my $allValues, '<', $inputParam) or die "Could not open file '$fullPath' $!";

	# Parse file and write to files
	my $writeFilePath;
	my $witeFile;
	while (my $row = <$allValues>) {

		if (index($row, $separatorForFile) == 0) {

			if (length $writeFilePath > 0) {
				close $witeFile;
			}

			# Create path for file
			chomp $row;
			print "$row\n";
			my @folderPathArray = split(' ', $row);
			print "@folderPathArray\n";
			$fileName = pop(@folderPathArray);
			print "$fileName\n";
			$writeFilePath = $folderPath . "/" . $fileName;

			# Open or create new file
			open ($witeFile, '>', $writeFilePath) or die "Could not create new loc file '$newLocFileName' $!";
		} else {
			
			next if (length $writeFilePath <= 0);
			chomp $row;
  			print $witeFile "$row\n";
		}
	}

	if (length $writeFilePath > 0) {
		close $witeFile;
	}

} else {

	# Create file flow

	# Open folder
	opendir FOLDER, $inputParam or die "Cannot open directory: $!";
	my @folder = readdir(FOLDER);
	my @locFiles;

	my $newLocFileName = "AllLocalization.strings";

	# Search all .strings files
	foreach(@folder) {
		next unless ($_ =~ m/\.strings/);
		next if ($_ =~ m/$newLocFileName/);
	    push(@locFiles, $_);
	}

	# Open or create new file for all strings
	my $newLocFilePath = $inputParam . "/" . "AllLocalization.txt";

	open (my $newLocFile, '>', $newLocFilePath) or die "Could not create new loc file '$newLocFileName' $!";

	# Write all files rows to one
	foreach(@locFiles) {
		print $newLocFile "\n$separatorForFile $_\n";

		my $fullPath = $inputParam . "/" . $_;
		open(my $simpleFile, '<', $fullPath) or die "Could not open file '$fullPath' $!";
		while (my $row = <$simpleFile>) {
	  		chomp $row;
	  		print $newLocFile "$row\n";
		}
		close $simpleFile;
	}

	close FOLDER;
}