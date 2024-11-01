import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';

class AIChatController extends GetxController {
  final RxList<types.Message> messages = <types.Message>[].obs;
  final _user = const types.User(id: 'user-id');
  final _bot = const types.User(id: 'bot-id');

  // Define keywords, context words, and their associated responses
  final List<Map<String, dynamic>> botKnowledgeBase = [
    {
      "keyword": "you",
      "contexts": [
        {
          "words": ["how","help", "me"],
          "response":
              "I'm here to guide you through your academic journey! Whether you need help finding scholarships, internships, or just advice, I've got your back."
        },
        {
          "words": ["what", "can", "do"],
          "response":
              "I can help you discover new opportunities, connect with resources, and even answer your questions about the app and its features!"
        },
        {
          "words": ["do",  "offer", "support"],
          "response":
              "Absolutely! If you ever need assistance or have questions, just reach out to me, and I’ll make sure you get the help you need."
        },
        {
          "words": ["what", "can",  "offer"],
          "response":
              "I offer personalized support in finding scholarships, internships, and guidance on career pathways tailored to your interests and skills."
        },
        {
          "words": ["how", "can",  "assist", "me"],
          "response":
              "I can assist you by answering your questions, providing resources, and connecting you with opportunities to help you achieve your goals."
        },
        {
          "words": ["can",  "help", "me", "with"],
          "response":
              "Absolutely! Just let me know what you need help with, whether it's scholarship applications, resume building, or interview preparation."
        },
        {
          "words": ["do",  "know", "any", "opportunities"],
          "response":
              "Yes, I can provide you with a list of available scholarships, internships, and other resources relevant to your field of study!"
        },
        {
          "words": ["are",  "available", "to", "talk"],
          "response":
              "I'm always here for you! Feel free to ask me anything, and I'll respond as quickly as possible."
        },
        {
          "words": ["what", "do",  "recommend"],
          "response":
              "I recommend exploring opportunities that match your skills and interests. Let me know what you're passionate about, and I can help!"
        },
        {
          "words": ["how", "do",  "support", "students"],
          "response":
              "I support students by providing access to information on scholarships, internships, and career advice to help them succeed in their academic journeys."
        },
        {
          "words": ["can",  "connect", "me", "with"],
          "response":
              "Certainly! I can connect you with resources and professionals who can provide valuable insights into your desired field."
        },
        {
          "words": ["how", "do",  "know", "so", "much"],
          "response":
              "I've been designed to provide information based on extensive data from various educational resources and current opportunities available to students."
        },
        {
          "words": ["what", "makes",  "unique"],
          "response":
              "What makes me unique is my ability to provide tailored guidance and support based on your specific needs and aspirations."
        },
        {
          "words": ["what", "is", "your", "role"],
          "response":
              "My role is to assist you in navigating your educational path by providing relevant information, support, and encouragement."
        },
        {
          "words": ["how", "can",  "make", "my", "life", "easier"],
          "response":
              "I can simplify your search for scholarships and internships by curating relevant information and offering tips for your applications."
        },
        {
          "words": ["what", "should", "I", "ask", "you"],
          "response":
              "You can ask me anything related to scholarships, internships, career advice, or even tips for studying effectively!"
        },
        {
          "words": ["can",  "suggest", "resources"],
          "response":
              "Absolutely! I can suggest a variety of resources, including websites, books, and tools to help you in your academic journey."
        },
        {
          "words": [
            "how",
            "can",
            
            "help",
            "me",
            "prepare",
            "for",
            "interviews"
          ],
          "response":
              "I can provide you with interview tips, common questions, and resources to help you practice and feel more confident."
        },
        {
          "words": ["what", "if", "I", "need", "more", "help"],
          "response":
              "If you need more help, just let me know! I'm here to provide additional resources or connect you with professionals who can assist further."
        },
        {
          "words": ["what", "do",  "think", "about"],
          "response":
              "I think education is a powerful tool! It's important to leverage all available resources to achieve your goals."
        },
        {
          "words": ["what", "do",  "suggest", "I", "do"],
          "response":
              "I suggest starting by exploring available scholarships and internships that align with your interests and skills. Let’s find the right fit for you!"
        },
        {
          "words": [],
          "response":
              "You're not alone in this! I'm here to provide you with the support and resources to help you succeed academically and professionally."
        }
      ]
    },
    {
      "keyword": "you and me",
      "contexts": [
        {
          "words": ["how", "can",  "work", "together"],
          "response":
              "Together, we can explore various opportunities that match your skills and interests, helping you take steps toward your goals!"
        },
        {
          "words": ["what", "do",  "achieve"],
          "response":
              "By collaborating, we can unlock exciting pathways for scholarships, internships, and valuable resources tailored just for you!"
        },
        {
          "words": ["can",  "make", "it", "happen"],
          "response":
              "Absolutely! I'm here to assist you in every step, making sure you have the best chance to succeed in your endeavors."
        },
        {
          "words": [],
          "response":
              "You and I make a great team! Let’s tackle your academic challenges together and find the best opportunities for you."
        }
      ]
    },
    {
      "keyword": "your journey",
      "contexts": [
        {
          "words": ["how", "to", "navigate", ],
          "response":
              "I can help you navigate your journey by providing personalized recommendations based on your academic background and interests."
        },
        {
          "words": ["what", "does",  "look", "like"],
          "response":
              "Your journey is unique! Together, we can map out a path filled with scholarships, internships, and career guidance tailored just for you."
        },
        {
          "words": ["can",  "guide", "my journey"],
          "response":
              "Definitely! I'm here to support and guide you through every twist and turn, ensuring you have the resources you need to thrive."
        },
        {
          "words": [],
          "response":
              "Embarking on your journey can be exciting yet challenging. Together, we'll make sure you have the best tools and information to succeed!"
        }
      ]
    },
    {
      "keyword": "your success",
      "contexts": [
        {
          "words": ["how", "to", "achieve", ],
          "response":
              "Your success is my priority! By using the resources and opportunities available, we can work towards your academic and career goals together."
        },
        {
          "words": ["what", "does",  "mean"],
          "response":
              "Your success means reaching your full potential, whether it’s landing that dream internship or securing a scholarship to further your education."
        },
        {
          "words": ["can", "you", "help", "me", "find", "success"],
          "response":
              "Of course! I’m here to assist you in identifying and pursuing the right opportunities that align with your aspirations."
        },
        {
          "words": [],
          "response":
              "Let’s celebrate your achievements together! I'm dedicated to helping you reach your success, one step at a time."
        }
      ]
    },
    {
      "keyword": "your goals",
      "contexts": [
        {
          "words": ["how", "can", "I", "achieve", "my", "goals"],
          "response":
              "To achieve your goals, I recommend setting specific, measurable objectives and using resources and support to guide you along the way."
        },
        {
          "words": ["what", "are", "your", "goals", "for", "me"],
          "response":
              "My goal for you is to help you find the right opportunities and resources that align with your aspirations and make your journey smoother."
        },
        {
          "words": ["can", "you", "help", "me", "set", "my", "goals"],
          "response":
              "Absolutely! I can help you define your goals and create a plan to work toward achieving them step by step."
        },
        {
          "words": ["how", "do", "you", "support", "my", "goals"],
          "response":
              "I support your goals by providing relevant information, resources, and advice tailored to your specific objectives and aspirations."
        }
      ]
    },
    {
      "keyword": "your feedback",
      "contexts": [
        {
          "words": ["how", "can", "I", "give", "you", "feedback"],
          "response":
              "You can give me feedback by sharing your thoughts on how I can improve or what features you'd like to see in the app!"
        },
        {
          "words": ["why", "is", "your feedback", "important"],
          "response":
              "Your feedback is important because it helps me understand your needs better and improve the resources I provide."
        },
        {
          "words": ["what", "do", "you", "do", "with", "your feedback"],
          "response":
              "I use your feedback to enhance the user experience and ensure that I'm providing the most relevant and helpful information."
        },
        {
          "words": ["can", "you", "implement", "my", "feedback"],
          "response":
              "Yes! I’ll do my best to implement your feedback to improve the app and make it more user-friendly."
        }
      ]
    },
    {
      "keyword": "your experience",
      "contexts": [
        {
          "words": ["how", "has", "your experience", "helped", "students"],
          "response":
              "My experience has helped students navigate their academic journeys by providing tailored advice, resources, and support."
        },
        {
          "words": ["what", "is", "your experience", "in", "education"],
          "response":
              "I’m equipped with knowledge from various educational sources, helping students find scholarships, internships, and career paths that suit them."
        },
        {
          "words": ["can", "you", "share", "your experience"],
          "response":
              "Sure! I've gathered insights from numerous successful students and professionals to provide relevant guidance for your journey."
        },
        {
          "words": ["how", "can", "your experience", "benefit", "me"],
          "response":
              "My experience allows me to offer you personalized support, helping you find opportunities that match your goals and aspirations."
        }
      ]
    },
    {
      "keyword": "student profile",
      "contexts": [
        {
          "words": ["how", "to", "create"],
          "response":
              "To create your student profile, go to the Profile section, fill in details like your name, qualification, contact information, and update your picture. Ensure your qualifications are accurate to apply for relevant posts."
        },
        {
          "words": ["how", "to", "update"],
          "response":
              "To update your profile, go to the Profile section and tap the edit icon. You can modify details such as your qualifications, contact information, and profile picture."
        },
        {
          "words": [],
          "response":
              "Your student profile includes key details like your name, contact information, qualifications, and profile picture. Ensure it's updated to get the best matches for posts!"
        }
      ]
    },
    {
      "keyword": "admin dashboard",
      "contexts": [
        {
          "words": ["what", "is"],
          "response":
              "The Admin Dashboard allows admins to add posts, manage applications, communicate with students, and categorize opportunities in StudentSphere. It’s a centralized hub for managing opportunities."
        },
        {
          "words": ["how", "to", "use"],
          "response":
              "Admins can use the dashboard to post opportunities under various categories, review student applications, accept or reject requests, and open chat rooms for further communication."
        },
        {
          "words": [],
          "response":
              "The Admin Dashboard helps admins manage posts and applications efficiently. Need guidance on posting opportunities or managing applications?"
        }
      ]
    },
    {
      "keyword": "notifications",
      "contexts": [
        {
          "words": ["how", "to", "receive"],
          "response":
              "Students receive notifications when a new post is added, their application status changes, or when an admin accepts their request. Ensure notifications are enabled in your settings."
        },
        {
          "words": ["why", "not", "working"],
          "response":
              "If notifications are not working, check your device settings to ensure notifications are enabled for StudentSphere. Also, ensure you're logged into the app."
        },
        {
          "words": [],
          "response":
              "Notifications keep students updated on new posts and application statuses. Need help enabling notifications?"
        }
      ]
    },
    {
      "keyword": "events",
      "contexts": [
        {
          "words": ["what", "are"],
          "response":
              "Events in StudentSphere include academic and professional opportunities such as conferences, webinars, and workshops. Students can browse and apply based on their interests and qualifications."
        },
        {
          "words": ["how", "to", "register"],
          "response":
              "To register for an event, go to the Events category, select the event you're interested in, and tap 'Apply'. If registration requires an external link, use the 'Link Apply' option."
        },
        {
          "words": ["what", "events", "available"],
          "response":
              "Currently, we have career fairs, scholarship workshops, and internship networking events available for students."
        },
        {
          "words": ["how", "to", "join", "event"],
          "response":
              "To join an event, register through our Events section in the app. You will receive a confirmation and further details via email."
        },
        {
          "words": ["importance", "of", "attending", "events"],
          "response":
              "Attending events helps you network, stay updated on industry trends, and access new opportunities in your field of interest."
        },
        {
          "words": [],
          "response":
              "Explore upcoming events in your region through our app, whether you're interested in career talks, workshops, or conferences."
        }
      ]
    },
    {
      "keyword": "scholarships",
      "contexts": [
        {
          "words": ["how", "to", "find"],
          "response":
              "To find scholarships, go to the Scholarships category. Browse the available options and apply to the ones that match your qualifications."
        },
        {
          "words": ["what", "is"],
          "response":
              "Scholarships in StudentSphere are financial aid opportunities for students based on their academic achievements, qualifications, or specific criteria like gender or field of study."
        },
        {
          "words": ["what", "are"],
          "response":
              "Scholarships are financial aids provided to students to support their education, usually based on academic achievements or specific criteria."
        },
        {
          "words": ["how", "to", "apply"],
          "response":
              "To apply for a scholarship, review eligibility criteria, prepare required documents like transcripts and essays, and submit the application through the provided portal."
        },
        {
          "words": ["available", "scholarships"],
          "response":
              "Currently, you can explore scholarships such as Fulbright, Erasmus Mundus, and local government-funded programs available on StudentSphere."
        },
        {
          "words": [],
          "response":
              "Looking for scholarships? Our platform provides a curated list of opportunities based on your qualifications."
        }
      ]
    },
    {
      "keyword": "internships",
      "contexts": [
        {
          "words": ["what", "is"],
          "response":
              "Internships on StudentSphere are opportunities for students to gain real-world work experience in their field of study, usually for a fixed period, and can sometimes lead to full-time jobs."
        },
        {
          "words": ["how", "to", "apply"],
          "response":
              "To apply for internships, go to the Internships category, browse the available opportunities, and apply. Ensure you meet the qualification criteria before applying."
        },
        {
          "words": ["how", "to", "find"],
          "response":
              "You can find internships by browsing through our career section, applying via platforms like LinkedIn, Indeed, or through university partnerships."
        },
        {
          "words": ["benefits", "of", "internships"],
          "response":
              "Internships provide hands-on experience in your field, enhance your resume, and often lead to job opportunities after graduation."
        },
        {
          "words": ["how", "long"],
          "response":
              "Internship durations vary, typically ranging from 3 to 6 months, depending on the company's requirements."
        },
        {
          "words": [],
          "response":
              "Looking for internships to boost your career? Explore opportunities in fields like IT, Marketing, Engineering, and more on StudentSphere."
        }
      ]
    },
    {
      "keyword": "career guidance",
      "contexts": [
        {
          "words": ["what", "is"],
          "response":
              "Career Guidance in StudentSphere includes resources and posts designed to help students with career decisions, job preparation, and professional growth."
        },
        {
          "words": ["how", "to", "access"],
          "response":
              "You can access career guidance posts by navigating to the Career Guidance category. Here you'll find articles, webinars, and mentorship opportunities."
        },
        {
          "words": ["how", "to", "get"],
          "response":
              "You can get personalized career guidance by speaking with our counselors through the career section or scheduling an appointment."
        },
        {
          "words": ["importance", "of", "career", "guidance"],
          "response":
              "Career guidance is crucial as it helps students make informed decisions about their academic and professional future, ensuring better career outcomes."
        },
        {
          "words": [],
          "response":
              "Need help deciding your career path? Our expert advisors are here to guide you with personalized recommendations."
        }
      ]
    },
    {
      "keyword": "my applications",
      "contexts": [
        {
          "words": ["how", "to", "track"],
          "response":
              "You can track the status of your applications in the 'My Applications' section. Here, you'll see whether your application is pending, accepted, or rejected."
        },
        {
          "words": ["why", "can't", "apply", "again"],
          "response":
              "If you've already applied for a post, you cannot apply again unless the admin reopens the application window. Check your 'My Applications' section for updates."
        },
        {
          "words": [],
          "response":
              "In the 'My Applications' section, you can track all your submitted applications and see their current status."
        }
      ]
    },
    {
      "keyword": "admin posts",
      "contexts": [
        {
          "words": ["how", "to", "add"],
          "response":
              "Admins can add posts by navigating to the Admin Dashboard, selecting the category, and filling in the necessary details such as title, description, and qualifications required."
        },
        {
          "words": ["how", "to", "delete"],
          "response":
              "To delete a post, go to the Admin Dashboard, select the post you want to remove, and tap the delete option."
        },
        {
          "words": [],
          "response":
              "Admins can manage posts easily from the Admin Dashboard, including adding, editing, and deleting posts for students."
        }
      ]
    },
    {
      "keyword": "chatroom",
      "contexts": [
        {
          "words": ["how", "to", "start"],
          "response":
              "A chatroom is automatically created when the admin accepts your application. You can access the chat from your application details and communicate directly with the admin."
        },
        {
          "words": ["how", "to", "send", "documents"],
          "response":
              "Once the chatroom is open, you can send documents or messages directly to the admin to provide additional details for your application."
        },
        {
          "words": [],
          "response":
              "Chatrooms enable direct communication between students and admins after an application is accepted. Need help starting a chat?"
        }
      ]
    },
    {
      "keyword": "job search",
      "contexts": [
        {
          "words": ["how", "to", "start"],
          "response":
              "Start your job search by building a strong resume, setting up alerts on job portals like LinkedIn or Indeed, and applying directly through StudentSphere."
        },
        {
          "words": ["best", "platforms"],
          "response":
              "Some of the best platforms for job search are LinkedIn, Indeed, Glassdoor, and our StudentSphere job board, which lists student-centric opportunities."
        },
        {
          "words": ["tips", "for", "job", "search"],
          "response":
              "Tailor your resume for each job, network with professionals in your field, and keep an eye on the latest openings on our app."
        },
        {
          "words": [],
          "response":
              "Need help with job searching? We provide job listings, tips for interviews, and resources for building your career."
        }
      ]
    },
    {
      "keyword": "qualifications",
      "contexts": [
        {
          "words": ["what", "are", "types", "of"],
          "response":
              "Common qualifications include Matric, Intermediate, Bachelor, Master, and PhD. Each level opens new academic and career opportunities."
        },
        {
          "words": ["how", "to", "improve"],
          "response":
              "To improve your qualifications, pursue further education, certifications, or skill-based courses relevant to your career path."
        },
        {
          "words": ["importance", "of", "qualifications"],
          "response":
              "Qualifications are important as they enhance your expertise, open career doors, and often increase earning potential."
        },
        {
          "words": [],
          "response":
              "Interested in upgrading your qualifications? We provide resources on degrees, certifications, and skill-building courses."
        }
      ]
    },
    {
      "keyword": "resume building",
      "contexts": [
        {
          "words": ["how", "to", "build", "resume"],
          "response":
              "Start by organizing your academic achievements, skills, and work experience. Tailor it to the job you are applying for, and keep it concise."
        },
        {
          "words": ["what", "should", "include"],
          "response":
              "Include your contact details, professional summary, education, work experience, skills, and any certifications or awards."
        },
        {
          "words": ["tips", "for", "resume"],
          "response":
              "Keep it clear and concise, tailor it to the job, and focus on your accomplishments rather than just duties."
        },
        {
          "words": [],
          "response":
              "Need help building a resume? Our platform provides templates and expert advice to create a strong, professional resume."
        }
      ]
    },
    {
      "keyword": "interview tips",
      "contexts": [
        {
          "words": ["how", "to", "prepare"],
          "response":
              "Prepare by researching the company, practicing common interview questions, and reviewing your resume to align with the job description."
        },
        {
          "words": ["best", "tips"],
          "response":
              "Best tips include dressing appropriately, maintaining eye contact, giving concise answers, and asking insightful questions at the end of the interview."
        },
        {
          "words": ["what", "to", "expect"],
          "response":
              "Expect questions about your qualifications, experience, and how you handle challenges. Be ready to demonstrate your skills with examples."
        },
        {
          "words": [],
          "response":
              "Looking for interview tips? We offer preparation guides, common questions, and advice for acing your next interview."
        }
      ]
    },
    {
      "keyword": "app features",
      "contexts": [
        {
          "words": ["what", "features", "does", "the", "app", "have"],
          "response":
              "The StudentSphere app offers features like scholarship listings, internship opportunities, career guidance, event notifications, and an AI chatbot for instant support."
        },
        {
          "words": ["how", "to", "navigate"],
          "response":
              "Navigate the app easily using the bottom navigation bar to access categories like scholarships, internships, and events."
        },
        {
          "words": ["can", "I", "get", "notifications"],
          "response":
              "Yes, you can enable notifications in the settings to receive updates about new opportunities and events tailored to your interests."
        },
        {
          "words": [],
          "response":
              "Curious about what our app can do? Explore various sections dedicated to student needs, including personalized recommendations."
        }
      ]
    },
    {
      "keyword": "support",
      "contexts": [
        {
          "words": ["how", "to", "contact", "support"],
          "response":
              "You can contact support via the 'Help' section in the app or email us directly at support@studentsphere.com."
        },
        {
          "words": ["what", "support", "is", "available"],
          "response":
              "We provide support for app functionality, scholarship inquiries, internship applications, and general career advice."
        },
        {
          "words": ["response", "time"],
          "response":
              "Our support team aims to respond within 24 hours during business days."
        },
        {
          "words": [],
          "response":
              "Need assistance? Our support team is here to help with any questions or issues you may have while using the app."
        }
      ]
    },
    {
      "keyword": "registration",
      "contexts": [
        {
          "words": ["how", "to", "register"],
          "response":
              "To register, download the app, fill in your details, and create an account using your email or social media accounts."
        },
        {
          "words": ["do", "I", "need", "to", "pay"],
          "response":
              "No, registration and using the StudentSphere app are completely free for all students."
        },
        {
          "words": ["what", "information", "is", "needed"],
          "response":
              "You will need to provide basic information like your name, email, academic details, and field of interest during registration."
        },
        {
          "words": [],
          "response":
              "Want to get started? Register today to unlock personalized opportunities and resources tailored to your academic journey."
        }
      ]
    },
    {
      "keyword": "user profile",
      "contexts": [
        {
          "words": ["how", "to", "edit"],
          "response":
              "You can edit your user profile by navigating to the 'Profile' section and selecting 'Edit Profile' to update your information."
        },
        {
          "words": ["why", "update"],
          "response":
              "Updating your profile ensures you receive relevant recommendations for scholarships and internships based on your current qualifications and interests."
        },
        {
          "words": ["can", "I", "add", "skills"],
          "response":
              "Yes, you can add skills and qualifications to your profile to enhance your visibility to potential employers and scholarship providers."
        },
        {
          "words": [],
          "response":
              "Keep your profile updated to make the most of your StudentSphere experience and to receive opportunities tailored to you."
        }
      ]
    },
    {
      "keyword": "feedback",
      "contexts": [
        {
          "words": ["how", "to", "give", "feedback"],
          "response":
              "You can provide feedback through the 'Feedback' section in the app or by emailing us your suggestions at feedback@studentsphere.com."
        },
        {
          "words": ["why", "is", "feedback", "important"],
          "response":
              "Your feedback helps us improve the app and better serve students' needs, ensuring we provide valuable resources and features."
        },
        {
          "words": ["can", "I", "rate", "the", "app"],
          "response":
              "Yes, we encourage users to rate the app in the app store, as it helps others find us and gives us insights into user satisfaction."
        },
        {
          "words": [],
          "response":
              "We value your opinion! Share your thoughts with us to help enhance your StudentSphere experience."
        }
      ]
    },
    {
      "keyword": "privacy policy",
      "contexts": [
        {
          "words": ["what", "is", "the", "privacy", "policy"],
          "response":
              "Our privacy policy outlines how we collect, use, and protect your personal information while using the StudentSphere app."
        },
        {
          "words": ["how", "is", "my", "data", "protected"],
          "response":
              "We use encryption and secure servers to protect your data, ensuring that your personal information remains confidential."
        },
        {
          "words": ["can", "I", "delete", "my", "account"],
          "response":
              "Yes, you can delete your account from the 'Account Settings' section, which will remove your personal data from our systems."
        },
        {
          "words": [],
          "response":
              "Your privacy is important to us! Review our privacy policy in the app for more details on how we handle your information."
        }
      ]
    },
    {
      "keyword": "updates",
      "contexts": [
        {
          "words": ["how", "to", "get", "updates"],
          "response":
              "Enable notifications in the app settings to receive updates about new scholarships, internships, and events tailored for you."
        },
        {
          "words": ["what", "are", "recent", "updates"],
          "response":
              "Recent updates include new scholarship listings, upcoming events, and enhanced features for better user experience."
        },
        {
          "words": ["can", "I", "see", "previous", "updates"],
          "response":
              "Yes, you can view the update history in the app settings to stay informed about the latest changes."
        },
        {
          "words": [],
          "response":
              "Stay updated! Follow us on social media for the latest news and updates about StudentSphere."
        }
      ]
    },
    {
      "keyword": "flutter",
      "contexts": [
        {
          "words": ["what", "is"],
          "response":
              "Flutter is an open-source UI toolkit by Google for building natively compiled applications for mobile, web, and desktop from a single codebase."
        },
        {
          "words": ["how", "to", "install"],
          "response":
              "You can install Flutter by downloading the Flutter SDK from the official website and setting up your development environment with Android Studio or Visual Studio Code."
        },
        {
          "words": ["why", "use"],
          "response":
              "Flutter provides a fast development process, beautiful UI, and supports multiple platforms from a single codebase, which saves time and effort."
        },
        {
          "words": ["where", "to", "learn"],
          "response":
              "You can learn Flutter from official documentation, YouTube tutorials, or platforms like Udemy and Coursera."
        },
        {
          "words": ["when", "to", "use"],
          "response":
              "Flutter is ideal when you want to build visually attractive apps with a single codebase for Android, iOS, and web."
        },
        {
          "words": [],
          "response":
              "Flutter is a powerful toolkit for building cross-platform apps. How can I assist you further?"
        }
      ]
    },
    {
      "keyword": "firebase",
      "contexts": [
        {
          "words": ["what", "is"],
          "response":
              "Firebase is a platform developed by Google that provides cloud services like databases, authentication, analytics, and hosting for mobile and web applications."
        },
        {
          "words": ["how", "to", "integrate"],
          "response":
              "To integrate Firebase in Flutter, add Firebase packages in your pubspec.yaml file, set up Firebase Console, and configure your Android/iOS app with Firebase SDK."
        },
        {
          "words": ["why", "use"],
          "response":
              "Firebase simplifies backend development by offering tools like real-time databases, authentication, analytics, and cloud functions, which reduce time to market."
        },
        {
          "words": ["how", "to", "authenticate"],
          "response":
              "Firebase Authentication allows you to sign in users using email/password, Google, Facebook, and other providers with just a few lines of code."
        },
        {
          "words": ["where", "to", "store", "data"],
          "response":
              "Firebase offers Cloud Firestore and the Realtime Database for storing and syncing data between your app and the cloud."
        },
        {
          "words": [],
          "response":
              "Firebase offers a variety of tools to help manage your app's backend. Would you like assistance with Firebase?"
        }
      ]
    },
    {
      "keyword": "state management",
      "contexts": [
        {
          "words": ["what", "is"],
          "response":
              "State management refers to the way app data and UI are managed to ensure consistent behavior across the app. It is essential in Flutter to handle dynamic data."
        },
        {
          "words": ["how", "to", "implement"],
          "response":
              "You can implement state management in Flutter using solutions like Provider, Riverpod, Bloc, or GetX."
        },
        {
          "words": ["why", "use", "provider"],
          "response":
              "Provider is a simple and efficient way to manage state in Flutter, especially in smaller apps. It helps separate UI from business logic."
        },
        {
          "words": ["which", "state", "management"],
          "response":
              "Popular state management solutions in Flutter include Provider, Riverpod, Bloc, and GetX, each with its pros and cons depending on app complexity."
        },
        {
          "words": ["when", "to", "use"],
          "response":
              "Use state management when your app has dynamic content or when data needs to be shared across different widgets or screens."
        },
        {
          "words": [],
          "response":
              "Need help choosing the right state management solution for your app? Let me know your requirements."
        }
      ]
    },
    {
      "keyword": "flutter widget",
      "contexts": [
        {
          "words": ["what", "is"],
          "response":
              "In Flutter, a widget is a building block of the UI. Everything you see on the app screen is a widget, such as text, buttons, and layouts."
        },
        {
          "words": ["how", "to", "create"],
          "response":
              "To create a widget in Flutter, extend the StatelessWidget or StatefulWidget class and implement the build method to define the UI."
        },
        {
          "words": ["when", "to", "use", "stateful"],
          "response":
              "Use a StatefulWidget when your UI depends on some state or changes over time, like when handling user input or animations."
        },
        {
          "words": ["what", "is", "stateless"],
          "response":
              "A StatelessWidget is a widget that does not require any mutable state. The UI remains the same once built."
        },
        {
          "words": [],
          "response":
              "Widgets are the core of Flutter's UI framework. Want to know more about specific Flutter widgets?"
        }
      ]
    },
    {
      "keyword": "firebase firestore",
      "contexts": [
        {
          "words": ["what", "is"],
          "response":
              "Cloud Firestore is a flexible, scalable database for mobile, web, and server development from Firebase and Google Cloud."
        },
        {
          "words": ["how", "to", "use"],
          "response":
              "You can use Firestore in Flutter by adding the Firestore package, then reading and writing data using collections and documents."
        },
        {
          "words": ["how", "to", "query"],
          "response":
              "You can query Firestore collections using methods like where, limit, orderBy, and others to retrieve data efficiently."
        },
        {
          "words": ["how", "to", "store", "data"],
          "response":
              "To store data in Firestore, you need to define collections and documents, then write the data using Firestore's set or add methods."
        },
        {
          "words": [],
          "response":
              "Firestore offers real-time data synchronization across clients. How can I help you with Firestore?"
        }
      ]
    },
    {
      "keyword": "flutter layout",
      "contexts": [
        {
          "words": ["how", "to", "align"],
          "response":
              "You can align widgets in Flutter using the Align widget or other layout widgets like Row, Column, and Stack to arrange your UI."
        },
        {
          "words": ["what", "is", "flex"],
          "response":
              "The Flex widget is a parent for Row and Column widgets. It controls the layout of its children by defining how they should be arranged."
        },
        {
          "words": ["how", "to", "center"],
          "response":
              "You can center a widget in Flutter by using the Center widget, which places the child widget in the middle of the parent widget."
        },
        {
          "words": [],
          "response":
              "Flutter offers flexible layout options like Row, Column, Stack, and GridView. Want more information about building layouts?"
        }
      ]
    },
    {
      "keyword": "firebase authentication",
      "contexts": [
        {
          "words": ["how", "to", "set up"],
          "response":
              "To set up Firebase Authentication in Flutter, add the Firebase Auth package, configure your project in Firebase Console, and implement the authentication flows."
        },
        {
          "words": ["what", "is"],
          "response":
              "Firebase Authentication provides backend services for authenticating users via email/password, phone numbers, and third-party providers like Google and Facebook."
        },
        {
          "words": ["how", "to", "reset", "password"],
          "response":
              "You can implement password reset functionality by calling Firebase Auth's sendPasswordResetEmail method."
        },
        {
          "words": [],
          "response":
              "Firebase Authentication simplifies user sign-ins for mobile and web apps. Need help setting up authentication?"
        }
      ]
    },
    {
      "keyword": "bloc",
      "contexts": [
        {
          "words": ["what", "is"],
          "response":
              "Bloc (Business Logic Component) is a state management solution in Flutter that separates UI from business logic, making your app more scalable."
        },
        {
          "words": ["how", "to", "use"],
          "response":
              "To use Bloc in Flutter, install the bloc package, create events and states, and use the BlocBuilder to react to state changes."
        },
        {
          "words": ["why", "use"],
          "response":
              "Bloc is useful for large-scale applications with complex state logic, ensuring separation of concerns and testability."
        },
        {
          "words": [],
          "response":
              "Bloc is a powerful state management pattern for managing app state efficiently. Need help implementing Bloc?"
        }
      ]
    },
    {
      "keyword": "provider",
      "contexts": [
        {
          "words": ["what", "is"],
          "response":
              "Provider is a Flutter state management library that allows efficient sharing of data between widgets, helping to manage state reactively."
        },
        {
          "words": ["how", "to", "use"],
          "response":
              "To use Provider, wrap your app with ChangeNotifierProvider, and access the data using Provider.of or Consumer widgets."
        },
        {
          "words": ["why", "use"],
          "response":
              "Provider is an easy and scalable state management approach that works well for both small and large applications."
        },
        {
          "words": [],
          "response":
              "Provider is a popular choice for state management in Flutter. Need help with Provider setup?"
        }
      ]
    }
  ];
  // Add more keywords as needed

// Function to handle sending a message
  void sendMessage(String userMessage) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: userMessage,
    );

    messages.insert(0, textMessage);
    _botReply(userMessage);
  }

// Function to generate a response from the bot based on user input
void _botReply(String userMessage) {
  String response =
      "I'm not sure how to respond to that. Could you rephrase your question?";

  // Search through the knowledge base for a keyword match first
  for (var entry in botKnowledgeBase) {
    if (userMessage.toLowerCase().contains(entry["keyword"])) {
      bool contextFound = false;

      // Check for word matches in contexts
      for (var context in entry["contexts"]) {
        if (context["words"]
            .any((word) => userMessage.toLowerCase().contains(word))) {
          response = context["response"];
          contextFound = true;
          break; // Exit if a context match is found
        }
      }

      // If no specific context was found, provide the default response for that keyword
      if (!contextFound) {
        final defaultContext = entry["contexts"].firstWhere(
          (context) => (context["words"] as List).isEmpty,
          orElse: () => {
            "response": "I'm not sure how to respond to that."
          }, // Default fallback response
        );
        response = defaultContext["response"];
      }
      break; // Exit the loop once we've found a keyword match
    }
  }

  // If no keyword matches were found, then check for exact phrase matches
  if (response == "I'm not sure how to respond to that. Could you rephrase your question?") {
    if (!_checkForExactPhraseMatch(userMessage, response)) {
      response = "I'm not sure how to respond to that. Could you rephrase your question?";
    }
  }

  // Prepare the bot's message
  final botMessage = types.TextMessage(
    author: _bot,
    createdAt: DateTime.now().millisecondsSinceEpoch,
    id: const Uuid().v4(),
    text: response,
  );

  // Add the bot's message after a short delay for a natural feel
  Future.delayed(const Duration(milliseconds: 500), () {
    messages.insert(0, botMessage);
  });
}

// Function to check for exact phrase matches
bool _checkForExactPhraseMatch(String userMessage, String response) {
  // Loop through the default contexts
  for (var context in defaultContexts) {
    for (var phrase in context["exact_phrases"] ?? []) {
      if (userMessage.toLowerCase().contains(phrase.toLowerCase())) {
        response = context["response"];
        // Insert the response into the messages list
        final botMessage = types.TextMessage(
          author: _bot,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: const Uuid().v4(),
          text: response,
        );

        // Add the bot's message after a short delay for a natural feel
        Future.delayed(const Duration(milliseconds: 500), () {
          messages.insert(0, botMessage);
        });
        return true; // Match found, so we return true
      }
    }
  }
  return false; // No match found
}

  final List<Map<String, dynamic>> defaultContexts = [
    // Existing contexts
    {
      "exact_phrases": ["who are you", "what is your name"],
      "response":
          "I am an AI chatbot, designed to assist you with various queries, especially around Flutter, Firebase, and more. You can call me your virtual assistant!"
    },
    {
      "exact_phrases": ["who made you", "who created you", "who developed you"],
      "response":
          "I was created by AbdulRehman Arain, a skilled Flutter developer with a passion for building smart, helpful tools."
    },
    {
      "exact_phrases": ["why do you exist", "what is your purpose"],
      "response":
          "I exist to help answer your questions and assist you with tasks, especially related to software development and technical issues. Let me know how I can help!"
    },
    {
      "exact_phrases": ["are you human", "what are you"],
      "response":
          "I am not a human, but an AI assistant. I can help you with tasks like answering questions and providing information, much like a helpful human would!"
    },
    {
      "exact_phrases": ["what can you do", "how can you help me"],
      "response":
          "I can help with many things, from answering technical questions about Flutter and Firebase to providing general knowledge or guidance. Just ask me anything!"
    },
    {
      "exact_phrases": ["who created you", "who is your developer"],
      "response":
          "I was developed by AbdulRehman Arain, who has expertise in building useful applications and chatbots like me!"
    },

    // New contexts
    {
      "exact_phrases": ["what is Flutter", "can you explain Flutter"],
      "response":
          "Flutter is an open-source UI software development kit created by Google. It allows developers to create natively compiled applications for mobile, web, and desktop from a single codebase."
    },
    {
      "exact_phrases": ["what is Firebase", "how does Firebase work"],
      "response":
          "Firebase is a platform developed by Google for creating mobile and web applications. It offers a variety of tools and services, including real-time databases, authentication, and cloud storage."
    },
    {
      "exact_phrases": [
        "what is state management",
        "how to manage state in Flutter"
      ],
      "response":
          "State management in Flutter refers to the management of the state of your app, ensuring that the user interface reflects the current data. Popular methods include Provider, Riverpod, and Bloc."
    },
    {
      "exact_phrases": [
        "how to install Flutter",
        "what are the steps to set up Flutter"
      ],
      "response":
          "To install Flutter, download the Flutter SDK from the official site, add it to your PATH, and run the Flutter doctor command to check for dependencies. Follow the setup instructions for your specific OS."
    },
    {
      "exact_phrases": ["what is Dart", "why is Dart used"],
      "response":
          "Dart is an open-source programming language developed by Google, used primarily for building mobile, desktop, server, and web applications. It is the language behind Flutter."
    },
    {
      "exact_phrases": [
        "how do I create a Flutter project",
        "what is the command to start a Flutter project"
      ],
      "response":
          "You can create a new Flutter project using the command `flutter create project_name` in your terminal, where 'project_name' is the desired name of your project."
    },
    {
      "exact_phrases": [
        "what are widgets in Flutter",
        "can you explain Flutter widgets"
      ],
      "response":
          "Widgets are the building blocks of a Flutter app's user interface. Everything in Flutter is a widget, from layout elements to UI components."
    },
    {
      "exact_phrases": [
        "how to handle errors in Flutter",
        "what is error handling in Flutter"
      ],
      "response":
          "Error handling in Flutter can be done using try-catch blocks for synchronous code or using Future.catchError for asynchronous code. It helps to manage exceptions and improve app stability."
    },
    {
      "exact_phrases": ["what's new", "what's happening"],
      "response":
          "Not much! I'm here to help you with any questions you have. What can I do for you?"
    },
    {
      "exact_phrases": ["how's your day", "how's your day going"],
      "response":
          "I don't experience days like you do, but I'm ready to assist you with whatever you need!"
    },
    // {
    //   "exact_phrases": ["yo", "sup"],
    //   "response": "Hey there! How can I assist you today? Just let me know!"
    // },
    {
      "exact_phrases": ["long time no see", "it's been a while"],
      "response":
          "Welcome back! I'm here to help, so what can I assist you with today?"
    },
    {
      "exact_phrases": ["thank you", "thanks"],
      "response":
          "You're welcome! If you have any more questions or need help, feel free to ask!"
    },
    {
      "exact_phrases": ["good to see you", "great to see you"],
      "response": "It's great to see you too! How can I help you today?"
    },
    {
      "exact_phrases": ["how's life", "how are things"],
      "response":
          "I’m just a program, but I'm here to help you with any inquiries you might have!"
    },
    {
      "exact_phrases": ["welcome", "thank you for having me"],
      "response": "You're always welcome here! How can I assist you today?"
    },
  ];
}
