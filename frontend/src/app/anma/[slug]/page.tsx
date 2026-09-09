import type { Metadata } from 'next';
import { notFound } from 'next/navigation';
import Image from 'next/image';

import { fetchContributions, fetchMemorial, fetchMemorials, memorialUrl } from '@/lib/api';

interface PageProps {
  params: Promise<{ slug: string }>;
}

/**
 * Per-dossier metadata.
 *
 * This is the reason the frontend moved to SSR. A memorial shared in a family
 * WhatsApp group used to preview as the generic site card; now the preview
 * carries the person's name, their years and their portrait.
 */
export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { slug } = await params;
  const memorial = await fetchMemorial(slug);

  if (!memorial) {
    return { title: 'Kütük bulunamadı | Remembered' };
  }

  const years = [memorial.birthDate, memorial.deathDate].filter(Boolean).join(' — ');
  const title = `${memorial.fullName} | Remembered`;
  const description =
    memorial.lifeQuote?.trim() ||
    [memorial.profession, years].filter(Boolean).join(' • ') ||
    'Yaşayan bir anma kütüğü.';

  return {
    title,
    description,
    alternates: { canonical: memorialUrl(memorial.slug || memorial.id) },
    openGraph: {
      type: 'profile',
      title,
      description,
      url: memorialUrl(memorial.slug || memorial.id),
      images: memorial.heroImage ? [{ url: memorial.heroImage, alt: memorial.fullName }] : undefined,
    },
    twitter: {
      card: 'summary_large_image',
      title,
      description,
      images: memorial.heroImage ? [memorial.heroImage] : undefined,
    },
  };
}

/** Pre-render the curated dossiers; anything else is rendered on demand. */
export async function generateStaticParams() {
  const memorials = await fetchMemorials();
  return memorials.slice(0, 50).map((m) => ({ slug: m.slug }));
}

export default async function MemorialPage({ params }: PageProps) {
  const { slug } = await params;
  const memorial = await fetchMemorial(slug);

  if (!memorial) notFound();

  const contributions = await fetchContributions(slug);
  const years = [memorial.birthDate, memorial.deathDate].filter(Boolean).join(' — ');

  return (
    <main className="mx-auto max-w-3xl px-4 py-10">
      <article>
        <header className="border-b-2 border-[#111111] pb-6">
          {memorial.isVerifiedHistoric && (
            <p className="mb-2 font-mono text-[11px] uppercase tracking-wider text-[#8C5828]">
              Doğrulanmış tarihî kişi
            </p>
          )}

          <h1 className="font-serif text-4xl font-black tracking-tight text-[#111111]">
            {memorial.fullName}
          </h1>

          {years && <p className="mt-1 font-mono text-sm text-[#666666]">{years}</p>}
          {memorial.profession && (
            <p className="mt-2 font-serif italic text-[#444444]">{memorial.profession}</p>
          )}

          {memorial.heroImage && (
            <Image
              src={memorial.heroImage}
              alt={memorial.fullName}
              width={1200}
              height={800}
              className="mt-6 w-full object-cover grayscale"
              unoptimized
              priority
            />
          )}
        </header>

        {memorial.lifeQuote && (
          <blockquote className="my-8 border-l-2 border-[#8C5828] pl-4 font-serif text-lg italic text-[#333333]">
            {memorial.lifeQuote}
          </blockquote>
        )}

        {memorial.biography && (
          <section className="my-8">
            <h2 className="mb-3 font-mono text-[11px] uppercase tracking-wider text-[#777777]">
              Yaşam öyküsü
            </h2>
            <div className="space-y-4 font-serif leading-relaxed text-[#333333]">
              {memorial.biography.split('\n').filter(Boolean).map((paragraph, index) => (
                <p key={index}>{paragraph}</p>
              ))}
            </div>
          </section>
        )}

        <section className="my-8 border-t border-[#E5E5DF] pt-6">
          <h2 className="mb-3 font-mono text-[11px] uppercase tracking-wider text-[#777777]">
            Anma
          </h2>
          <p className="font-serif text-[#444444]">
            {memorial.candleCount.toLocaleString('tr-TR')} mum yakıldı
            {contributions.length > 0 && `, ${contributions.length} saygı duruşu bırakıldı`}.
          </p>

          {contributions.length > 0 && (
            <ul className="mt-4 space-y-3">
              {contributions.slice(0, 20).map((contribution) => (
                <li key={contribution.id} className="border border-[#E5E5DF] bg-white p-3">
                  <p className="font-mono text-[10px] uppercase tracking-wider text-[#777777]">
                    {contribution.authorName || 'Bir ziyaretçi'}
                    {contribution.relation && ` • ${contribution.relation}`}
                  </p>
                  {contribution.body && (
                    <p className="mt-1 font-serif text-sm text-[#333333]">{contribution.body}</p>
                  )}
                </li>
              ))}
            </ul>
          )}
        </section>
      </article>
    </main>
  );
}
