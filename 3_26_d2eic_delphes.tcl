set ExecutionPath {
  ParticlePropagator
  ChargedHadronTrackingEfficiency
  ElectronTrackingEfficiency
  MuonTrackingEfficiency
  MomentumSmearing
  ECal
  HCal
  Calorimeter
  PID
  TreeWriter
}


#######################################
# Particle Propagator
#######################################

module ParticlePropagator ParticlePropagator {
  set InputArray Delphes/allParticles

  set OutputArray stableParticles


  set ChargedHadronOutputArray chargedHadron
  set ElectronOutputArray electron
  set MuonOutputArray muon

  set Radius 1.1
  set HalfLength 1.25

  set Bz 3.0
}

#######################################
# Momentum Resolution (Tracking)
#######################################

module MomentumSmearing MomentumSmearing {
  set InputArray ParticlePropagator/stableParticles
  set OutputArray stableParticles

  set ResolutionFormula { 0.60 / sqrt(energy) }
}

#######################################
# Tracking Efficiency
#######################################


module Efficiency ChargedHadronTrackingEfficiency {
  set InputArray ParticlePropagator/chargedHadron
  set OutputArray chargedHadron
  set EfficiencyFormula { (eta > -4.0 && eta < 4.0) * 1.0 }
}

module Efficiency ElectronTrackingEfficiency {
  set InputArray ParticlePropagator/electron
  set OutputArray electron
  set EfficiencyFormula { (eta > -4.0 && eta < 4.0) * 1.0 }
}

module Efficiency MuonTrackingEfficiency {
  set InputArray ParticlePropagator/muon
  set OutputArray muon
  set EfficiencyFormula { (eta > -4.0 && eta < 4.0) * 1.0 }
}

#######################################
# Calorimeters (ECal and HCal)
#######################################

module SimpleCalorimeter ECal {
  set ParticleInputArray ParticlePropagator/stableParticles
  set TrackInputArray ParticlePropagator/chargedHadron
  
  set TowerOutputArray ecalParticles

  set EtaPhiBins { 80 80 }
  set EnergyResolutionFormula { 0.05 / sqrt(energy) }
  set AcceptanceFormula { (eta > -4.0 && eta < 4.0) }
  set EnergyMin 0.5
}

module SimpleCalorimeter HCal {
  set ParticleInputArray ParticlePropagator/stableParticles
  set TrackInputArray ParticlePropagator/chargedHadron
  
  set TowerOutputArray hcalParticles

  set EtaPhiBins { 80 80 }
  set EnergyResolutionFormula { 0.05 / sqrt(energy) }
  set AcceptanceFormula { (eta > -4.0 && eta < 4.0) }
  set EnergyMin 0.5
}


module Merger Calorimeter {
  add InputArray ECal/ecalParticles
  add InputArray HCal/hcalParticles
  set OutputArray towers
}

#######################################
# PID Efficiencies
#######################################

module IdentificationMap PID {
  set InputArray ParticlePropagator/stableParticles
  set OutputArray particles

  set DefaultEfficiency 0.0 

  add EfficiencyFormula {2212} { (energy < 7.0)*0.90 + (energy >= 7.0 && energy <= 10.0)*(0.90 - (energy - 7.0)*(0.20/3.0)) + (energy > 10.0)*0.70 }
}

#######################################
# Tree Writer
#######################################

module TreeWriter TreeWriter {
  set FileName "delphes_output.root"
  set TreeName "Delphes"

  add Branch Delphes/allParticles Particle GenParticle
  add Branch MomentumSmearing/stableParticles Track Track
  add Branch Calorimeter/towers Tower Tower
}







