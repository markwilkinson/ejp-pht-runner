require './EJP/utils.rb'
require 'rdf'
require 'ldp_simple'



rdf =  RDF::Vocabulary.new("http://www.w3.org/1999/02/22-rdf-syntax-ns#")
dcat = RDF::Vocabulary.new("http://www.w3.org/ns/dcat#")
dc = RDF::Vocabulary.new("http://purl.org/dc/elements/1.1/")
dct = RDF::Vocabulary.new("http://purl.org/dc/terms/")
fund = RDF::Vocabulary.new("http://vocab.ox.ac.uk/projectfunding#")
skos =  RDF::Vocabulary.new("http://www.w3.org/2004/02/skos/core#")
dctype =  RDF::Vocabulary.new("http://purl.org/dc/dcmitype/")
foaf =  RDF::Vocabulary.new("http://xmlns.com/foaf/0.1/")
locn	 =  RDF::Vocabulary.new("http://www.w3.org/ns/locn#")
odrl	 =  RDF::Vocabulary.new("http://www.w3.org/ns/odrl/2/")
owl	 =  RDF::Vocabulary.new("http://www.w3.org/2002/07/owl#")
prov	 =  RDF::Vocabulary.new("http://www.w3.org/ns/prov#")
rdfs	 =  RDF::Vocabulary.new("http://www.w3.org/2000/01/rdf-schema#")
time	 =  RDF::Vocabulary.new("http://www.w3.org/2006/time#")
vcard	 =  RDF::Vocabulary.new("http://www.w3.org/2006/vcard/ns#")
xsd	 =  RDF::Vocabulary.new("http://www.w3.org/2001/XMLSchema#")
obo = RDF::Vocabulary.new("http://purl.obolibrary.org/obo/")
sio = RDF::Vocabulary.new("http://semanticscience.org/resource/")
rdcmeta = RDF::Vocabulary.new("http://rdf.biosemantics.org/ontologies/rd-connect/")
dbsnp = RDF::Vocabulary.new("http://identifiers.org/dbsnp:")
hgnc = RDF::Vocabulary.new("https://identifiers.org/hgnc:")
bioass = RDF::Vocabulary.new("http://www.bioassayontology.org/bao#")

prefixes = {sio: "http://semanticscience.org/resource/",
            obo: "http://purl.obolibrary.org/obo/",
            rdfs: "http://www.w3.org/2000/01/rdf-schema#",
            dbsnp:"http://identifiers.org/dbsnp:",
            hgnc: "https://identifiers.org/hgnc:",
            bioass: "http://www.bioassayontology.org/bao#",
            hgnc: "https://identifiers.org/hgnc:",
            rdcmeta: "http://rdf.biosemantics.org/ontologies/rd-connect/",
            ex: "http://example.org/",            
            
            } 
#DPPcontainer =  "http://45.131.82.47:8890/DAV/home/LDP/DPP/"
#DPPmetadata = "http://45.131.82.47:8890/DAV/home/LDP/DPP,meta"

#client = LDP::LDPClient.new({
#	:endpoint => "http://ldp.cbgp.upm.es:8890/DAV/home/LDP/Training/grazing/285525/",
#	:endpoint => "http://ejprd.fair-dtls.surf-hosted.nl:8890/DAV/home/LDP/EJP/",
#	:endpoint => "http://ejprd.fair-dtls.surf-hosted.nl:8890/DAV/home/LDP/EJP/erdri_catalog/",
#	:endpoint => DPPcontainer,
#	:username => "DPP",
#	:password => "dppdpp"})
#catalogue = client.toplevel_container

#

puts "\n\nCare Pathway\n\n"
  g = RDF::Graph.new() # a graph for the distribution
  
  tripllify("http://example.org/process", rdf.type, sio.process, g, nil, "process")
  tripllify("http://example.org/process", rdf.type, obo['NCIT_C142427'], g, nil, "clinical encounter")
	
  tripllify("http://example.org/process", rdf.type, obo['NCIT_C159705'], g, nil, "First confirmed visit" )
  
  tripllify("http://example.org/process", sio["start-date"], "2020-10-18T13:00:00", g)
  
  puts g.dump(:turtle, prefixes: prefixes)
#  triples = g.map {|s| [s.subject.to_s, s.predicate.to_s, s.object.to_s]}


puts "\n\nGenetic diagnosis\n\n"
  g = RDF::Graph.new() # a graph for the distribution
  
  tripllify("http://example.org/patientID", rdf.type, sio.identifier, g, "123456", "identifier")
  tripllify("http://example.org/patientID", rdf.type, rdcmeta.Pseudonym, g, nil, "Pseudonym")
  tripllify("http://example.org/patientID", sio['has-value'], "123456", g)

  tripllify("http://example.org/patientID", sio.denotes, "http://example.org/patientrole", g, nil, "Patient role")

  tripllify("http://example.org/patientrole", rdf.type, sio['patient-role'], g, nil, "Patient role")
  tripllify("http://example.org/patientrole", rdf.type, sio['role'], g, nil, "Role")

  tripllify("http://example.org/patientX", rdf.type, sio['patient'], g, nil, "Patient")
  tripllify("http://example.org/patientX", sio['has-role'], "http://example.org/patientrole", g, nil, nil)

  tripllify("http://example.org/patientX", obo['RO_0002162'], "http://example.org/patienttaxon", g, nil, "some taxon")
  tripllify("http://example.org/patienttaxon", rdf.type, obo['NCBITaxon_9606'], g, nil, "Homo sapiens")

  tripllify("http://example.org/patientrole", sio['is-realized-in'], "http://example.org/geneticdiagnosticprocess" , g, nil, "genetic diagnostic process")
  tripllify("http://example.org/geneticdiagnosticprocess", rdf.type, obo['NCIT_C15709'] , g, nil, "Genetic Testing")
  tripllify("http://example.org/geneticdiagnosticprocess", sio["start-date"], "2020-10-18T13:00:00", g, nil, nil)

  tripllify("http://example.org/geneticdiagnosticprocess", sio["has-output"], dbsnp.rs121909098, g, nil, "rs121909098")
  

  tripllify(dbsnp.rs121909098, rdf.type, obo['SO_0000694'], g, nil, "SNP")
  tripllify(dbsnp.rs121909098, rdf.type, obo['VariO_0138'], g, nil, "Variant")

#------  ow the gene
  tripllify(hgnc['2928'], rdf.type, sio.identifier, g, "HGNC:2928", "identifier")
  tripllify(hgnc['2928'], rdf.type, obo['NCIT_C48664'], g, "HGNC:2928", "Gene Identifier")
  tripllify(hgnc['2928'], sio['has-value'], "HGNC 2928", g)

  tripllify(hgnc['2928'], sio.denotes, "http://example.org/generole", g, nil, "Target gene role")

  tripllify("http://example.org/generole", rdf.type, bioass['BAO_0003064'], g, nil, "Target")
  tripllify("http://example.org/generole", rdf.type, sio['role'], g, nil, "Role")

  tripllify("http://example.org/geneX", rdf.type, obo['NCIT_C16612'], g, nil, "Gene")
  tripllify("http://example.org/geneX", sio['has-role'], "http://example.org/generole", g, nil, nil)

  tripllify("http://example.org/generole", sio['is-realized-in'], "http://example.org/geneticdiagnosticprocess" , g, nil, "genetic diagnostic process")




  puts g.dump(:turtle, prefixes: prefixes)


puts "\n\nUndiagnosed\n\n"
  g = RDF::Graph.new() # a graph for the distribution
  
  tripllify("http://example.org/patientID", rdf.type, sio.identifier, g, "123456", "identifier")
  tripllify("http://example.org/patientID", rdf.type, rdcmeta.Pseudonym, g, nil, "Pseudonym")
  tripllify("http://example.org/patientID", sio['has-value'], "123456", g)

  tripllify("http://example.org/patientID", sio.denotes, "http://example.org/patientrole", g, nil, "Patient role")

  tripllify("http://example.org/patientrole", rdf.type, sio['patient-role'], g, nil, "Patient role")
  tripllify("http://example.org/patientrole", rdf.type, sio['role'], g, nil, "Role")

  tripllify("http://example.org/patientX", rdf.type, sio['patient'], g, nil, "Patient")
  tripllify("http://example.org/patientX", sio['has-role'], "http://example.org/patientrole", g, nil, nil)

  tripllify("http://example.org/patientX", obo['RO_0002162'], "http://example.org/patienttaxon", g, nil, "some taxon")
  tripllify("http://example.org/patienttaxon", rdf.type, obo['NCBITaxon_9606'], g, nil, "Homo sapiens")

  tripllify("http://example.org/patientrole", sio['is-realized-in'], "http://example.org/medicaldiagnosticprocess" , g, nil, "medical diagnostic process")
  tripllify("http://example.org/medicaldiagnosticprocess", rdf.type, sio['medical-diagnosis'] , g, nil, "Medical Diagnosis")
  tripllify("http://example.org/medicaldiagnosticprocess", sio["start-date"], "2020-10-18T13:00:00", g, nil, nil)

  tripllify("http://example.org/medicaldiagnosticprocess", sio["has-output"], "http://example.org/medicaldiagnosticprocess#output1", g, nil, "Uncertain Diagnosis")
  tripllify("http://example.org/medicaldiagnosticprocess#output1", rdf.type, "https://snomedbrowser.com/Codes/Details/282292002", g, nil, "Uncertain Diagnosis")


  puts g.dump(:turtle, prefixes: prefixes)





puts "\n\nConsent\n\n"
  g = RDF::Graph.new() # a graph for the distribution
  
  tripllify("http://example.org/patientID", rdf.type, sio.identifier, g, "123456", "identifier")
  tripllify("http://example.org/patientID", rdf.type, rdcmeta.Pseudonym, g, nil, "Pseudonym")
  tripllify("http://example.org/patientID", sio['has-value'], "123456", g)

  tripllify("http://example.org/patientID", sio.denotes, "http://example.org/patientrole", g, nil, "Patient role")

  tripllify("http://example.org/patientrole", rdf.type, sio['patient-role'], g, nil, "Patient role")
  tripllify("http://example.org/patientrole", rdf.type, sio['role'], g, nil, "Role")

  tripllify("http://example.org/patientX", rdf.type, sio['patient'], g, nil, "Patient")
  tripllify("http://example.org/patientX", sio['has-role'], "http://example.org/patientrole", g, nil, nil)

  tripllify("http://example.org/patientX", obo['RO_0002162'], "http://example.org/patienttaxon", g, nil, "some taxon")
  tripllify("http://example.org/patienttaxon", rdf.type, obo['NCBITaxon_9606'], g, nil, "Homo sapiens")

  tripllify("http://example.org/patientrole", sio['is-realized-in'], "http://example.org/consentingprocess" , g, nil, "Consenting process")
  tripllify("http://example.org/consentingprocess", rdf.type, obo['ICO_0000196'] , g, nil, "Act of informed consenting")
  tripllify("http://example.org/consentingprocess", sio["start-date"], "2020-10-18T13:00:00", g, nil, nil)

  tripllify("http://example.org/consentingprocess", sio["has-output"], "http://example.org/my_consent_document.pdf", g, nil, "Consent Document")
  tripllify("http://example.org/my_consent_document.pdf", rdf.type, obo['OBIB_0000488'], g, nil, "Willingness to be contacted for a research study")


  puts g.dump(:turtle, prefixes: prefixes)




puts "\n\nSymptom onset\n\n"
  g = RDF::Graph.new() # a graph for the distribution
  
  tripllify("http://example.org/patientID", rdf.type, sio.identifier, g, "123456", "identifier")
  tripllify("http://example.org/patientID", rdf.type, rdcmeta.Pseudonym, g, nil, "Pseudonym")
  tripllify("http://example.org/patientID", sio['has-value'], "123456", g)

  tripllify("http://example.org/patientID", sio.denotes, "http://example.org/patientrole", g, nil, "Patient role")

  tripllify("http://example.org/patientrole", rdf.type, sio['patient-role'], g, nil, "Patient role")
  tripllify("http://example.org/patientrole", rdf.type, sio['role'], g, nil, "Role")

  tripllify("http://example.org/patientX", rdf.type, sio['patient'], g, nil, "Patient")
  tripllify("http://example.org/patientX", sio['has-role'], "http://example.org/patientrole", g, nil, nil)

  tripllify("http://example.org/patientX", obo['RO_0002162'], "http://example.org/patienttaxon", g, nil, "some taxon")
  tripllify("http://example.org/patienttaxon", rdf.type, obo['NCBITaxon_9606'], g, nil, "Homo sapiens")


  tripllify("http://example.org/patientX", sio['has-quality'], "http://example.org/birthdayquality", g, nil, "Birth Date")
  tripllify("http://example.org/birthdayquality", rdf.type, obo['NCIT_C68615'], g, nil, "Birth Date")
  #
  tripllify("http://example.org/birthdayquality", sio['has-measurement-value'], "http://example.org/birthdayquality#MV1" , g, nil, "2010-10-10")
  tripllify("http://example.org/birthdayquality#MV1", rdf.type, sio['measurement-value'], g, nil, "2010-10-10")
  tripllify("http://example.org/birthdayquality#MV1", sio['has-value'], "2015-10-18T13:00:00", g, nil, nil)
  
  
  tripllify("http://example.org/patientX", sio['has-quality'], "http://example.org/symptomquality", g, nil, "Symptom Onset")
  tripllify("http://example.org/symptomquality", rdf.type, obo['NCIT_C124353'], g, nil, "Symptom Onset")
  
  tripllify("http://example.org/symptomquality", sio['has-measurement-value'], "http://example.org/symptomquality#MV2", g, nil, nil)
  tripllify("http://example.org/symptomquality#MV2", rdf.type, sio['measurement-value'], g, nil, "This will depend on what symptom has been measured...")
  tripllify("http://example.org/symptomquality#MV2", sio['has-value'], "2015-10-18T13:00:00", g, nil, nil)


  puts g.dump(:turtle, prefixes: prefixes)
