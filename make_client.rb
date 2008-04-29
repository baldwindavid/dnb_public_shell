base_path = '~/Sites/client/'

puts "Enter main client directory name:"
client = gets.chomp!

puts "Are you working with a main client or subclient? ('1' for client or '2' for subclient)"
client_or_sub = gets.chomp!

if client_or_sub == '2'
  # create the subclients directory in main client if it doesn't already exist
  `mkdir #{base_path}#{client}/subclients`
  puts "What is the name of this subclient?"
  subclient = gets.chomp!
  client = "#{client}/subclients/#{subclient}"
end

`mkdir #{base_path}#{client}`
`mkdir #{base_path}#{client}/globals`
`mkdir #{base_path}#{client}/globals/proposals`
`mkdir #{base_path}#{client}/projects`

puts "Initial client structure created!"
current_structure = "
Stuff you've created...
#{client}
  - globals
    - proposals
  - projects"
puts current_structure

puts "Will there be a web project? (y or n)"
if gets.chomp! == 'y'
  `mkdir #{base_path}#{client}/projects/website`
  current_structure << "
    - website"
  puts current_structure
  puts "What is the name of the project? (example: mysite.net, somesite.subfolder, stuff.mystuff.net)"
  domain = gets.chomp!
  `mkdir #{base_path}#{client}/projects/website/#{domain}`
  puts "Website directory added!"
  current_structure << "
      - #{domain}"
  puts current_structure
  
  puts "Would you like to create a symlink in the www directory for this site? (y or n)"
  if gets.chomp! == 'y'
    puts "Is this a domain/subdomain or subfolder? ('1' for domain/subdomain or '2' for subfolder)"
    domain_type = gets.chomp!
    
    if domain_type == "1"
      `ln -s #{base_path}#{client}/projects/website/#{domain} ~/Sites/www/#{domain}`
      puts "Symlink created!"
      current_structure << "
  Symlink: ~/Sites/www/#{domain}"
    elsif domain_type == "2"
      subfolder = domain.gsub(/\.subfolder/, '')
      sym_name = (client == subfolder) ? subfolder : "#{client}.#{subfolder}"
      puts "Should the name of this symlink be '#{sym_name}' (y or n)"
      if gets.chomp! == "n"
        puts "Enter the name that you would like for this symlink?"
        sym_name = gets.chomp!
      end
      `ln -s #{base_path}#{client}/projects/website/#{domain} ~/Sites/www/subfolders/#{sym_name}`
      current_structure << "
  Symlink: ~/Sites/www/subfolders/#{sym_name}"
    end
    puts current_structure
  end  
  
end

puts "Are there any additional projects you would like to add to this client? (y or n)"
if gets.chomp! == 'y'
  puts 'Enter a comma-separated list of additional projects to add to this client:'
  projects = gets.chomp!
  projects.split(',').each do |project|
    project = project.strip.gsub(/[\s]/, '_').downcase
    `mkdir #{base_path}#{client}/projects/#{project}`
    current_structure << "
    - #{project}"
  end
  puts 'Projects Added!'
  puts current_structure
end