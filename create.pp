ec2_instance { 'Icinga Server':
  ensure                    => present,
  region                    => 'ap-south-1', 
  availability_zone         => 'ap-south-1b',
  subnet                    => 'subnet-a0eb55ed',
  image_id                  => 'ami-099fe766',
  instance_type             => 't2.micro',
  monitoring                => false,
  key_name                  => 'ami-docker',
  iam_instance_profile_name => 'A',
  security_groups           => ['puppet'],
  user_data                 => template('/home/ec2-user/icinga.sh'),
  tags                      => {
    tage_name   => 'icinga',
    },
  }
