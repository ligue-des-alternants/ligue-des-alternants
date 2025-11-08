import { type BlocksContent, BlocksRenderer } from '@strapi/blocks-react-renderer';

interface BlocksContentProps {
  content: BlocksContent;
}

export default function BlocksContent({ content }: BlocksContentProps) {
  if (!content) {
    return null;
  }

  return (
    <BlocksRenderer
      content={content}
      blocks={{
        paragraph: ({ children }) => (
          <p className="text-muted-foreground mt-6 max-w-3xl">{children}</p>
        ),
        heading: ({ children, level }) => {
          switch (level) {
            case 1:
              return <h1>{children}</h1>;
            case 2:
              return (
                <h2 className="text-foreground text-2xl font-semibold tracking-tight text-pretty">
                  {children}
                </h2>
              );
            case 3:
              return (
                <h3 className="text-foreground text-lg font-semibold tracking-tight text-pretty">
                  {children}
                </h3>
              );
            case 4:
              return (
                <h4 className="text-foreground text-base font-semibold tracking-tight text-pretty">
                  {children}
                </h4>
              );
            case 5:
              return (
                <h5 className="text-foregroundtext-sm font-semibold tracking-tight text-pretty">
                  {children}
                </h5>
              );
            case 6:
              return (
                <h6 className="text-foreground text-xs font-semibold tracking-tight text-pretty">
                  {children}
                </h6>
              );
            default:
              return <h1>{children}</h1>;
          }
        },
        image: ({ image }) => (
          <img
            src={image.url}
            alt={image.alternativeText || ''}
            width={image.width}
            height={image.height}
            className="mt-6 object-cover"
            loading="lazy"
          />
        ),
        list: ({ children, format }) => {
          if (format === 'ordered') {
            return (
              <ol className="text-muted-foreground mt-8 max-w-xl list-decimal space-y-4 pl-4">
                {children}
              </ol>
            );
          }

          return (
            <ul className="text-muted-foreground mt-8 max-w-xl list-disc space-y-4 pl-4">
              {children}
            </ul>
          );
        },
        quote: ({ children }) => (
          <blockquote className="border-primary text-muted-foreground border-l-4 pl-4 italic">
            {children}
          </blockquote>
        ),
        link: ({ children, url }) => (
          <a
            href={url}
            className="text-primary hover:text-primary/60 text-sm/6 font-semibold"
            target={url.startsWith('http') ? '_blank' : undefined}
            rel={url.startsWith('http') ? 'noopener noreferrer' : undefined}
          >
            {children}
          </a>
        ),
      }}
      modifiers={{
        bold: ({ children }) => (
          <strong className="text-foreground font-semibold">{children}</strong>
        ),
        italic: ({ children }) => <em className="italic">{children}</em>,
        underline: ({ children }) => <u className="underline underline-offset-2">{children}</u>,
        strikethrough: ({ children }) => <s className="line-through">{children}</s>,
      }}
    />
  );
}
