# delphes_d2eic
efforts towards DELPHES integration to D2EIC


./DelphesHepMC3 {path_to_card.tcl} {output.root} {events.hepmc}


./DelphesLHEF DelphesCard.tcl output.root events.lhe 

./DelphesPythia8 DelphesCard.tcl pythia_config.cmnd output.root 

./DelphesSTDHEP DelphesCard.tcl output.root events.stdhep
