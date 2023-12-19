import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ying_3_3/core/constants/global_variables.dart';

class Persistent {
  static List<String> taskCategoryList = [
    'Accounting',
    'Architecture & Construction',
    'Business',
    'Customer Service',
    'Data Analysis',
    'Development - Programming',
    'Design',
    'Education & Training',
    'Environmental Science',
    'Event Planning',
    'Financial Planning',
    'Graphic Design',
    'Healthcare & Medicine',
    'Human Resources',
    'Information Technology',
    'Legal & Compliance',
    'Logistics & Supply Chain',
    'Manufacturing & Operations',
    'Marketing',
    'Nonprofit Management',
    'Project Management',
    'Public Health',
    'Public Relations',
    'Quality Assurance',
    'Research & Development',
    'Sales & Customer Relations',
    'Social Media Management',
    'Writing & Editing'
  ];

  static Map<String, String?> categoryDefinitions = {
    'Accounting':
        'The systematic and comprehensive recording of financial transactions and the analysis, interpretation, and presentation of financial information.',
    'Architecture & Construction':
        'The art, science, and business of designing and constructing buildings and other structures.',
    'Business':
        'The organized efforts and activities of individuals to produce, sell, or buy goods and services with the aim of making a profit.',
    'Customer Service':
        'The assistance and support provided to customers before, during, and after the purchase of a product or service.',
    'Data Analysis':
        'The process of inspecting, cleaning, transforming, and modeling data to discover useful information, draw conclusions, and support decision-making.',
    'Development - Programming':
        'The process of creating, designing, and maintaining software applications or systems.',
    'Design':
        'The creation and arrangement of visual elements to communicate a message or evoke an emotional response.',
    'Education & Training':
        'The facilitation of learning and the acquisition of knowledge, skills, values, and habits.',
    'Environmental Science':
        'The study of the natural world and the impact of human activity on the environment.',
    'Event Planning':
        'The process of organizing and coordinating events, ranging from weddings and conferences to festivals and parties.',
    'Financial Planning':
        'The process of developing strategies to help individuals and businesses achieve their financial goals.',
    'Graphic Design':
        'The art of visual communication through the use of typography, photography, and illustration.',
    'Healthcare & Medicine':
        'The maintenance or improvement of health through the prevention, diagnosis, treatment, and recovery of illness or injury.',
    'Human Resources':
        'The management of personnel, including recruitment, training, compensation, and employee relations.',
    'Information Technology':
        'The use of computer systems, networks, and software to store, process, transmit, and retrieve information.',
    'Legal & Compliance':
        'The adherence to laws, regulations, and ethical standards within an organization or industry.',
    'Logistics & Supply Chain':
        'The management of the flow of goods and services from the point of origin to the point of consumption.',
    'Manufacturing & Operations':
        'The production of goods and the management of processes to ensure efficient and effective manufacturing.',
    'Marketing':
        'The activities a company undertakes to promote the buying, selling, and use of its products or services.',
    'Nonprofit Management':
        'The administration and coordination of activities within organizations that are not driven by profit motives.',
    'Project Management':
        'The application of knowledge, skills, tools, and techniques to project activities to meet project requirements.',
    'Public Health':
        'The science and art of preventing disease, prolonging life, and promoting health through organized efforts.',
    'Public Relations':
        'The strategic communication process that builds mutually beneficial relationships between organizations and their publics.',
    'Quality Assurance':
        'The systematic process of ensuring that a product or service meets specified requirements and quality standards.',
    'Research & Development':
        'The process of creating new knowledge, products, or processes through systematic investigation and experimentation.',
    'Sales & Customer Relations':
        'The activities and processes involved in promoting and selling products or services and maintaining positive customer relationships.',
    'Social Media Management':
        'The creation, curation, and management of content on social media platforms to achieve marketing and branding goals.',
    'Writing & Editing':
        'The creation and refinement of written content for various purposes, ensuring clarity, coherence, and effectiveness.'
  };

// GET USER DATA //
  void getUserData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    userName = userDoc.get('name');
    userImage = userDoc.get('userImage');
  }
}
